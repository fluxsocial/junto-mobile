import 'package:flutter/material.dart';

// typography + icons
import '../../custom_icons.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart';

class JuntoAppBar {

   static getJuntoAppBar(_juntoAppBarLogo, _juntoAppBarTitle, _juntoAppBarBorder) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.5),
          child: Container(
            height: 1.5,
            color: _juntoAppBarBorder
          )
        ),
        backgroundColor: JuntoPalette.juntoWhite,
        brightness: Brightness.light,
        elevation: 0,
        title:

          Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(
              children: <Widget>[                
                Image.asset(_juntoAppBarLogo,
                    height: 20.0, width: 20.0),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(_juntoAppBarTitle,
                      textAlign: TextAlign.center,
                      style: JuntoStyles.appbarTitle),
                ),
              ],
            ),

            Row(children: <Widget>[

              Container(                
                child: Icon(Icons.search, color: JuntoPalette.juntoSleek, size: 20),
              ),

              Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek, size: 20),
              )              
            ],)

        ]),
      ),
    );
  }
}
