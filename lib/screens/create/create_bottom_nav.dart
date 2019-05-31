import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import '../../typography/palette.dart';
import './create_actions.dart';

class CreateBottomNav extends StatelessWidget {
  Function switchTemplate;
  CreateBottomNav(this.switchTemplate);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 90,
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [

        Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,

            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    switchTemplate('longform');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),
              GestureDetector(
                  onTap: () {
                    switchTemplate('shortform');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),
              GestureDetector(
                  onTap: () {
                    switchTemplate('bullet');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),
              GestureDetector(
                  onTap: () {
                    switchTemplate('photo');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),
              GestureDetector(
                  onTap: () {
                    switchTemplate('events');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),
              GestureDetector(
                  onTap: () {
                    switchTemplate('music');
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Icon(CustomIcons.moon,
                          color: JuntoPalette.juntoSleek))),                       
            ],
          ),
        ),
        Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.white,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(CustomIcons.lotus,
                    color: JuntoPalette.juntoBlue, size: 30))),
      ]),
    );
  }
}
