import 'package:flutter/material.dart';

// typography + icons
import './../../custom_icons.dart';

import '../../route_animations/route_main_screens/route_main_screens.dart';
import '../../screens/spheres/spheres.dart';
import '../../screens/collective/collective.dart';
import '../../screens/pack/pack.dart';
import '../../screens/den/den.dart';


class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xffeeeeee), width: .75),
          ),
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoCollective()));

                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/spheres');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoSpheres()));
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
                },
                icon: Icon(
                  CustomIcons.lotus,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/pack');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoPack()));

                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/den');
                  Navigator.pushReplacement(context, CustomRoute(builder: (context) => JuntoDen()));
                
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
          ],
        ));
  }
}
