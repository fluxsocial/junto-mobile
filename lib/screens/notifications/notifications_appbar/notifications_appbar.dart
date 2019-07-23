import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../custom_icons.dart';

class NotificationsAppbar extends StatelessWidget {

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
                  child: Text('Notifications',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
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
                    JuntoPalette.juntoBlue,
                    JuntoPalette.juntoPurple
                  ]),
            ),
          )),
    );
  }
}
