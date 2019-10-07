import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/create_sphere/create_sphere.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_preview.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:provider/provider.dart';

/// This class renders the main screen for Spheres. It includes a widget to
/// create
/// a screen as well as a ListView of all the sphere previews
class JuntoSpheres extends StatefulWidget {
  const JuntoSpheres({
    Key key,
    @required this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;

  @override
  State<StatefulWidget> createState() => JuntoSpheresState();
}

class JuntoSpheresState extends State<JuntoSpheres> {
  UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  Widget buildError() {
    return Center(
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/junto-mobile__logo.png',
              height: 50.0,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Something went wrong :(',
              style: JuntoStyles.body,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          // Create sphere
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (BuildContext context) => CreateSphere(),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: JuntoPalette.juntoFade, width: .5),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: JuntoStyles.horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('Create a sphere', style: JuntoStyles.title),
                  Text(
                    '+',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<UserGroupsResponse>(
            future: _userProvider.getUserGroups(widget.userProfile.address),
            builder: (BuildContext context,
                AsyncSnapshot<UserGroupsResponse> snapshot) {
              if (snapshot.hasError) {
                return buildError();
              }
              if (snapshot.hasData && !snapshot.hasError) {
                final List<Group> ownedGroups = snapshot.data.owned
                    .where((Group group) => group.groupType == 'Sphere')
                    .toList();
                final List<Group> associatedGroups = snapshot.data.associated
                    .where((Group group) => group.groupType == 'Sphere')
                    .toList();
                final List<Group> userGroups = <Group>[
                  ...ownedGroups,
                  ...associatedGroups,
                ];
                return ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    for (Group group in userGroups)
                      SpherePreview(
                        group: group,
                      ),
                  ],
                );
              }
              return Container(
                height: 100.0,
                width: 100.0,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
