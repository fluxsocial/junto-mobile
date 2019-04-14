import 'package:flutter/material.dart';

import './../custom_icons.dart';
import './../screens/collective.dart';
import './../screens/spheres.dart';
import './../screens/pack.dart';
import './../screens/den.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      // type fixes alignment of BottomNavigationBarItem if x > 3
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JuntoSpheres()),
                );
              },
              icon: Icon(CustomIcons.home),
              color: Colors.black),
              title: SizedBox.shrink()

        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JuntoSpheres()),
                );
              },
              icon: Icon(CustomIcons.home),
              color: Colors.black),
              title: Container(height: 0, width: 0)

        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.home, color: Colors.black),
              title: Container(height: 0, width: 0)

        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JuntoPack()),
                );
              },
              icon: Icon(CustomIcons.home),
              color: Colors.black),
              title: Container(height: 0, width: 0)

        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JuntoDen()),
                );
              },
              icon: Icon(CustomIcons.home),
              color: Colors.black),
              title: Container(height: 0, width: 0)

        ),
    ]);
  }
}
