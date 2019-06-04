
import 'package:flutter/material.dart';

import './../../custom_icons.dart';

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
          Navigator.pushNamed(context, '/create');
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
