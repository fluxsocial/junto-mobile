import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/create_sphere.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Spheres extends StatefulWidget {
  const Spheres({
    this.userProfile,
    this.changeGroup,
  });

  final UserData userProfile;
  final Function changeGroup;

  @override
  State<StatefulWidget> createState() => SpheresState();
}

class SpheresState extends State<Spheres> with ListDistinct {
  UserData _userProfile;
  UserRepo _userProvider;
  Future<UserGroupsResponse> getSpheres;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
    _refreshSpheres();
  }

  Future<void> _refreshSpheres() async {
    try {
      await getUserInformation();
      setState(() {
        getSpheres = getUserGroups();
      });
    } on JuntoException catch (error) {
      JuntoDialog.showJuntoDialog(context, error.message, [DialogBack()]);
    }
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));
    setState(() {
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _userProvider.getUserGroups(_userProfile.user.address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Theme.of(context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Circles', style: Theme.of(context).textTheme.headline4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) => CreateSphere(
                          refreshSpheres: _refreshSpheres,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (_userProfile != null)
            FutureBuilder<UserGroupsResponse>(
              future: getSpheres,
              builder: (BuildContext context,
                  AsyncSnapshot<UserGroupsResponse> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Expanded(
                    child: Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child:
                            const Text('Hmm, something is up with our server'),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final List<Group> ownedGroups = snapshot.data.owned;
                  final List<Group> associatedGroups = snapshot.data.associated;
                  final List<Group> userSpheres =
                      distinct<Group>(ownedGroups, associatedGroups)
                          .where((Group group) => group.groupType == 'Sphere')
                          .toList();

                  return Expanded(
                      child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                      for (Group group in userSpheres)
                        GestureDetector(
                          onTap: () {
                            widget.changeGroup(group);
                          },
                          child: SpherePreview(
                            group: group,
                          ),
                        )
                    ],
                  ));
                }
                return Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: JuntoProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
