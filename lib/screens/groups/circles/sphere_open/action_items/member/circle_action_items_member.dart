import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/group_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_members/sphere_open_members.dart';
import 'package:provider/provider.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class CircleActionItemsMember extends StatelessWidget {
  const CircleActionItemsMember({
    Key key,
    @required this.sphere,
    @required this.userProfile,
  }) : super(key: key);

  final Group sphere;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    try {
                      Provider.of<GroupRepo>(context, listen: false)
                          .removeGroupMember(
                        sphere.address,
                        userProfile.address,
                      );

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e, s) {
                      logger.logException(e, s);
                    }
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Leave Sphere',
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    UserData user;
                    if (sphere.creator.runtimeType == String) {
                      user = await Provider.of<UserRepo>(context, listen: false)
                          .getUser(sphere.creator);
                    } else {
                      user = await Provider.of<UserRepo>(context, listen: false)
                          .getUser(sphere.creator['address']);
                    }

                    final query =
                        await Provider.of<GroupRepo>(context, listen: false)
                            .getGroupMembers(
                      sphere.address,
                      ExpressionQueryParams(paginationPosition: '0'),
                    );

                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => SphereOpenMembers(
                          group: sphere,
                          users: query.results,
                          creator: user.user,
                        ),
                      ),
                    );
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Invite Members',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
