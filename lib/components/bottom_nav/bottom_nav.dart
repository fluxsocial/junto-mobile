import 'package:flutter/material.dart';

// typography + icons
import './../../custom_icons.dart';

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
                  Navigator.pushReplacementNamed(context, '');
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/spheres');
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/create');

                },
                icon: Icon(
                  CustomIcons.lotus,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/pack');
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/den');
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
