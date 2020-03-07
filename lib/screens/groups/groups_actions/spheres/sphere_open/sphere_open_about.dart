import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_members/sphere_open_members.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class SphereOpenAbout extends StatelessWidget {
  const SphereOpenAbout({this.getMembers, this.group});
  final Future<List<Users>> getMembers;
  final Group group;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        FutureBuilder<List<Users>>(
            future: getMembers,
            builder:
                (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => SphereOpenMembers(
                          group: group,
                          users: snapshot.data,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: JuntoStyles.horizontalPadding,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .75,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(children: <Widget>[
                            for (Users user in snapshot.data)
                              if (snapshot.data.indexOf(user) < 7)
                                MemberAvatar(
                                  profilePicture: user.user.profilePicture,
                                  diameter: 28,
                                ),
                          ]),
                        ),
                        Container(
                          child: Text(
                            snapshot.data.length.toString() + ' Members',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bio / Purpose',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 10),
              Text(
                group.groupData.description,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
      ],
    );
  }
}
