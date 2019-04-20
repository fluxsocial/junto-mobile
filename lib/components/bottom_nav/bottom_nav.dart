import 'package:flutter/material.dart';

// typography + icons
import './../../custom_icons.dart';

// main screens
import './../../screens/collective/collective.dart';
import '../../screens/create/create.dart';
import './../../screens/den/den.dart';
import './../../screens/pack/pack.dart';
import './../../screens/spheres/spheres.dart';

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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoCollective()),
                  );
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoSpheres()),
                  );
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Create()),
                  );
                },
                icon: Icon(
                  CustomIcons.lotus,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoPack()),
                  );
                },
                icon: Icon(
                  CustomIcons.home,
                  size: 24.0,
                ),
                color: Colors.black),
            IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoDen()),
                  );
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
