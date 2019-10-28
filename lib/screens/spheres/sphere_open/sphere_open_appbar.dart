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
      backgroundColor: Colors.white,
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
                color: Colors.white,
                width: 42,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  CustomIcons.back,
                  color: JuntoPalette.juntoSleek,
                  size: 17,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Text(
                's/' + sphereHandle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff333333),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                SphereOpenActionItems().buildSphereOpenActionItems(context);
              },
              child: Container(
                width: 42,
                padding: const EdgeInsets.only(right: 10),
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: const Icon(
                  CustomIcons.more,
                  size: 24,
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
