import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/create_sphere.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class Spheres extends StatefulWidget {
  const Spheres({this.userProfile, this.changeGroup});

  final UserData userProfile;
  final Function changeGroup;
  @override
  State<StatefulWidget> createState() {
    return SpheresState();
  }
}

class SpheresState extends State<Spheres> with ListDistinct {
  String _userAddress;
  UserData _userProfile;
  UserRepo _userProvider;

  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  @override
  void initState() {
    super.initState();

    getUserInformation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _userProvider = Provider.of<UserRepo>(context);
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => _userProvider.getUserGroups(_userProfile.user.address),
    );
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
                  Text('Spheres', style: Theme.of(context).textTheme.display1),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<void>(
                          builder: (BuildContext context) => CreateSphere(),
                        ),
                      );
                    },
                    child: Icon(Icons.add, size: 24, color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Container(
            //   height: 50,
            //   color: Theme.of(context).backgroundColor,
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //           padding: const EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: const Color(0xff555555),
            //           ),
            //           child: Text(
            //             'All',
            //             style: TextStyle(
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.w700,
            //                 color: Colors.white,
            //                 decoration: TextDecoration.none),
            //           ))
            //     ],
            //   ),
            // ),
            if (_userProfile != null)
              FutureBuilder<UserGroupsResponse>(
                future: getUserGroups(),
                builder: (BuildContext context,
                    AsyncSnapshot<UserGroupsResponse> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Expanded(
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, -50),
                          child: const Text(
                              'Hmm, something is up with our server'),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final List<Group> ownedGroups = snapshot.data.owned;
                    final List<Group> associatedGroups =
                        snapshot.data.associated;
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
          ]),
    );
  }
}
