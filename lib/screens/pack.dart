
import 'package:flutter/material.dart';

import './../theme.dart';
import './../custom_icons.dart';
import './../components/bottom_nav/bottom_nav.dart';

class JuntoPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(
            backgroundColor: JuntoTheme.juntoWhite,
            // backgroundColor: Colors.blue,
            brightness: Brightness.light,
            elevation: 0,   
            title: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Row(
                children: <Widget>[
                  Image.asset('assets/images/junto-mobile__logo--pack.png',
                      height: 20.0, width: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'PACKS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: JuntoTheme.juntoSleek,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3),
                    ),
                  ),
                ],
              ),

          IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(CustomIcons.moon),
              iconSize: 20.0,
              color: JuntoTheme.juntoSleek,
              tooltip: 'open notifcations',
              onPressed: () {
                // ...
              },
            ),
          ])
        ),),        


        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.purple),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              width: 1000,
              color: Colors.white,
              foregroundDecoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey),
                ),
              ),
              child: Row(children: [
                IconButton(
                  onPressed: () {},
                  color: Colors.blue,
                  alignment: Alignment(-1.0, 0),
                  icon: Icon(Icons.search),
                  padding: EdgeInsets.all(0.0),
                ),
                Text(
                  'search packs',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                )
              ]),
            )
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
