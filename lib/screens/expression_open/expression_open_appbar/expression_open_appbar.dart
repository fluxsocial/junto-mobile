
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../custom_icons.dart';

class ExpressionOpenAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
AppBar(
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
                  color: JuntoPalette.juntoSleek, size: 24,),
            ),
            Container(
              child: Icon(CustomIcons.more, size: 20)
            )
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
                    Color(0xffeeeeee),
                    Color(0xffeeeeee),
                  ]),
            ),
          )),
    );
  }
}