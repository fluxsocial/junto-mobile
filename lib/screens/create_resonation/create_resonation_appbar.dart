import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class CreateResonationAppbar extends StatelessWidget {
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
                padding: EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  CustomIcons.back,
                  color: JuntoPalette.juntoSleek,
                  size: 17,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  // resonate expression
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: const Text(
                    'resonate',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ))
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
