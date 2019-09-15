import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

class ExpressionOpenAppbar extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
              margin: EdgeInsets.only(right: 10),
              child: Icon(CustomIcons.half_lotus, size: 14),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: <double>[0.1, 0.9],
              colors: <Color>[
                JuntoPalette.juntoFade,
                JuntoPalette.juntoFade,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
