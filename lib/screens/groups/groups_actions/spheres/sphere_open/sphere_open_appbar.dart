import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/action_items/creator/action_items.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/action_items/member/action_items.dart';

class SphereOpenAppbar extends StatelessWidget {
  const SphereOpenAppbar(
      {Key key,
      @required this.group,
      @required this.relationToGroup,
      @required this.userAddress})
      : super(key: key);

  final Group group;
  final String userAddress;
  final Map<String, dynamic> relationToGroup;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  CustomIcons.spheres,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text(
                    's/' + group.groupData.sphereHandle,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      CustomIcons.moon,
                      size: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return relationToGroup['creator']
                              ? OwnerActionItems(sphere: group)
                              : MemberActionItems(
                                  sphere: group,
                                  userAddress: userAddress,
                                );
                        });
                  },
                  child: Container(
                    width: 38,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      CustomIcons.morevertical,
                      size: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: .75,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
