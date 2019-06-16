import 'package:flutter/material.dart';

import '../../../../typography/palette.dart';
import '../../../../custom_icons.dart';

class PackOpenAppbar extends StatelessWidget {
  final packTitle;
  final packUser;
  final packImage;

  PackOpenAppbar(this.packTitle, this.packUser, this.packImage);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(CustomIcons.back_arrow_left,
                  color: JuntoPalette.juntoSleek, size: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(packTitle,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
                ClipOval(
                  child: Image.asset(
                    packImage,
                    height: 27.0,
                    width: 27.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: 
      PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    0.1,
                    0.9
                  ],
                  colors: [
                    JuntoPalette.juntoPurple,
                    JuntoPalette.juntoPurpleLight
                  ]),
            ),
          )),
    );
  }
}
