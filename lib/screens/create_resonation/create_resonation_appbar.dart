import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_action_items.dart';
class CreateResonationAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              child: Container(
                color: Colors.white,
                width: 38,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back_arrow_left,
                  color: JuntoPalette.juntoSleek,
                  size: 28,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                SphereOpenActionItems().buildSphereOpenActionItems(context);
              },
              child: Container(
                width: 38,
                color: Colors.white,
                alignment: Alignment.centerRight,
                child: Text('resonate')
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
