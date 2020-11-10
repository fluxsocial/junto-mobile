import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class CirclesListAll extends StatelessWidget with ListDistinct {
  const CirclesListAll({
    this.userProfile,
    this.getUserGroups,
  });

  final UserData userProfile;
  final getUserGroups;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (userProfile != null)
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
                        'Hmm, something is up...',
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                print('snapshot has data');

                final List<Group> ownedGroups = snapshot.data.owned;
                final List<Group> associatedGroups = snapshot.data.associated;
                print(ownedGroups.first.groupData.name);
                print(associatedGroups);

                final List<Group> userSpheres = distinct<Group>(
                  ownedGroups,
                  associatedGroups,
                ).where((Group group) => group.groupType == 'Sphere').toList();

                userSpheres.forEach((sphere) => print(sphere.creator));

                return Expanded(
                    child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    for (Group group in userSpheres)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SphereOpen(group: group),
                            ),
                          );
                        },
                        child: CirclePreview(
                          group: group,
                        ),
                      ),
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
    );
  }
}
