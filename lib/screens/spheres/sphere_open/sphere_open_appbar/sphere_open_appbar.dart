import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
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
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                CustomIcons.back_arrow_left,
                color: JuntoPalette.juntoSleek,
                size: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Text('/s/' + sphereHandle, style: JuntoStyles.title),
            ),
            GestureDetector(
              onTap: () {
                SphereOpenActionItems().buildSphereOpenActionItems(context);
              },
              child: Container(
                child: Icon(
                  CustomIcons.more,
                  size: 20,
                  color: Color(0xff333333),
                ),
              ),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: JuntoPalette.juntoFade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
