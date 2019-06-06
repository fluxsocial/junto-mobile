
import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart';

class JuntoAppBar extends StatelessWidget {
  final juntoAppBarLogo;
  final juntoAppBarTitle;
  final juntoAppBarBorderRight;
  final juntoAppBarBorderLeft;
  final navNotifications;

  JuntoAppBar(this.juntoAppBarLogo, this.juntoAppBarTitle, 
  this.juntoAppBarBorderRight, this.juntoAppBarBorderLeft, this.navNotifications);

  @override
  Widget build(BuildContext context) {
    return     
        AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
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
                      juntoAppBarBorderLeft,
                      juntoAppBarBorderRight
                    ])),
              )),
          backgroundColor: JuntoPalette.juntoWhite,
          brightness: Brightness.light,
          elevation: 0,
          titleSpacing: 0.0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Row(
                        children: <Widget>[
                          Image.asset(juntoAppBarLogo,
                              height: 20.0, width: 20.0),
                          Container(
                            margin: EdgeInsets.only(left: 7.5),
                            child: Text(juntoAppBarTitle,
                                textAlign: TextAlign.center,
                                style: JuntoStyles.appbarTitle),
                          ),
                        ],
                      ),
                    );
                  }),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.search,
                            color: JuntoPalette.juntoSleek, size: 20),
                      ),
                      GestureDetector(
                          onTap: () {
                            navNotifications();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 7.5),
                            child: Icon(CustomIcons.moon,
                                color: JuntoPalette.juntoSleek, size: 20),
                          ))
                    ],
                  )
                ]),
          )
    );
  }  
}
