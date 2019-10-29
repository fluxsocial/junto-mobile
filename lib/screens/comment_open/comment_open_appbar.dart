import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class CommentOpenAppbar extends StatelessWidget {
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
        // padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back,
                  color: JuntoPalette.juntoGrey,
                  size: 17,
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {

            //   },
            //   child: Container(
            //     color: Colors.transparent,
            //     padding: EdgeInsets.only(right: 10),
            //     width: 42,
            //     alignment: Alignment.centerRight,
            //     child: const Icon(
            //       CustomIcons.lotus,
            //       size: 20,
            //       color: Color(0xff333333),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: .75,
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
