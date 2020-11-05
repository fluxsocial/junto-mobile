import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
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

                return Expanded(
                    child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    for (Group group in userSpheres)
                      SpherePreview(
                        group: group,
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
