import 'package:flutter/material.dart';

import './../custom_icons.dart';
import './../components/bottom_nav/bottom_nav.dart';

class JuntoDen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: <Widget>[
              Image.asset('assets/images/junto-mobile__logo--den.png',
                  height: 24.0, width: 24.0),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  'DEN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CustomIcons.moon),
              color: Colors.black,
              tooltip: 'Open shopping cart',
              onPressed: () {
                // ...
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.black38),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
