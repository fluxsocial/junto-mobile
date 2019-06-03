
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/scoped_user.dart';


// typography + icons
import './../../custom_icons.dart';
import './../../typography/palette.dart';
import '../../route_animations/route_main_screens/route_main_screens.dart';
import '../../screens/collective/collective.dart';
import '../../screens/spheres/spheres.dart';
import '../../screens/pack/pack.dart';
import '../../screens/den/den.dart';


class BottomNav extends StatefulWidget { 
  final currentIndex;
  final setIndex;
  BottomNav(this.currentIndex, this.setIndex);

  @override
  State<StatefulWidget> createState() {

    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {

  @override
  Widget build(BuildContext context) { 
    return 
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffeeeeee), width: .75),
        ),
      ),
      height: 45,                  
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
      GestureDetector(
        onTap:() {
          widget.setIndex(0);
        },
        child: Icon(CustomIcons.home, color: widget.currentIndex == 0 ? Color(0xff333333) : Color(0xff999999))
      ),

      GestureDetector(
        onTap:() {
          widget.setIndex(1);
        },
        child: Icon(CustomIcons.home, color: widget.currentIndex == 1 ? Color(0xff333333) : Color(0xff999999))
      ),

      GestureDetector(
        onTap:() {
          // widget.setIndex(2);
        },
        child: Icon(CustomIcons.lotus, color: Color(0xff999999))
      ),

      GestureDetector(
        onTap:() {
          widget.setIndex(2);
        },
        child: Icon(CustomIcons.home, color: widget.currentIndex == 2 ? Color(0xff333333) : Color(0xff999999))
      ),

      GestureDetector(
        onTap:() {
          widget.setIndex(3);
        },
        child: Icon(CustomIcons.home, color: widget.currentIndex == 3 ? Color(0xff333333) : Color(0xff999999))
      )                  
    ],)
  );    
  }
}
