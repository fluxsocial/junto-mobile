import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart';

class JuntoAppBar {
  static getJuntoAppBar(_juntoAppBarLogo, _juntoAppBarTitle,
      _juntoAppBarBorderLeft, _juntoAppBarBorderRight, _navNotifications) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0),
      child: AppBar(
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
                      _juntoAppBarBorderLeft,
                      _juntoAppBarBorderRight
                    ])),
                // color: _juntoAppBarBorder
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
                          Image.asset(_juntoAppBarLogo,
                              height: 20.0, width: 20.0),
                          Container(
                            margin: EdgeInsets.only(left: 7.5),
                            child: Text(_juntoAppBarTitle,
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
                            _navNotifications();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 7.5),
                            child: Icon(CustomIcons.moon,
                                color: JuntoPalette.juntoSleek, size: 20),
                          ))
                    ],
                  )
                ]),
          )),
    );
  }
}
