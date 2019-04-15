import 'package:flutter/material.dart';

import './../custom_icons.dart';
import './../components/bottom_nav/bottom_nav.dart';

class JuntoSpheres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: <Widget>[
              Image.asset('assets/images/junto-mobile__logo--spheres.png',
                  height: 24.0, width: 24.0),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  'SPHERES',
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
                  bottom: BorderSide(width: 1.5, color: Colors.green),
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
                    color: Colors.blue,
                    alignment: Alignment(-1.0, 0),
                    icon: Icon(Icons.search),
                    padding: EdgeInsets.all(0.0),
                  ),
                  Text('search spheres',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500))
                ]))
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
