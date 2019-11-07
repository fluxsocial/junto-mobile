import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_action_items.dart';

class SphereOpenAppbar extends StatelessWidget {
  const SphereOpenAppbar(this.sphereHandle, this.sphereImage);

  /// The handle of the given sphere
  final String sphereHandle;
  final String sphereImage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back,
                  color: Theme.of(context).primaryColorDark,
                  size: 17,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Text('s/' + sphereHandle,
                  style: Theme.of(context).textTheme.subhead),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => SphereOpenActionItems(),
                );
              },
              child: Container(
                width: 42,
                padding: const EdgeInsets.only(right: 10),
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: Icon(
                  CustomIcons.more,
                  size: 24,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
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
