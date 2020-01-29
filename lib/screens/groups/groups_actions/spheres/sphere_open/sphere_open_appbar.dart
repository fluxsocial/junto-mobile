import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_action_items.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';

class SphereOpenAppbar extends StatelessWidget {
  const SphereOpenAppbar({Key key, @required this.group}) : super(key: key);

  final Group group;

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
                Icon(CustomIcons.spheres,
                    color: Theme.of(context).primaryColor, size: 20),
                // Container(
                //   alignment: Alignment.center,
                //   height: 32.0,
                //   width: 32.0,
                //   decoration: BoxDecoration(
                //     gradient: const LinearGradient(
                //       begin: Alignment.bottomLeft,
                //       end: Alignment.topRight,
                //       stops: <double>[0.3, 0.9],
                //       colors: <Color>[
                //         JuntoPalette.juntoSecondary,
                //         JuntoPalette.juntoPrimary,
                //       ],
                //     ),
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                //   child: const Icon(
                //     CustomIcons.spheres,
                //     color: Colors.white,
                //     size: 14,
                //   ),
                // ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text('s/' + group.groupData.sphereHandle,
                      style: Theme.of(context).textTheme.subtitle1),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      GlobalSearch.route((_) {}),
                    );
                  },
                  child: Container(
                    width: 38,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.search,
                        size: 22, color: Theme.of(context).primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(CustomIcons.moon,
                        size: 22, color: Theme.of(context).primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) =>
                          SphereOpenActionItems(sphere: group),
                    );
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
