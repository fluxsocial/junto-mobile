
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

class ExpressionOpenProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // profile picture
                ClipOval(
                  child: Image.asset(
                    'assets/images/junto-mobile__eric.png',
                    height: 36.0,
                    width: 36.0,
                    fit: BoxFit.cover,
                  ),
                ),

                // profile name and handle
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Eric Yang',
                        style: TextStyle(
                            color: JuntoPalette.juntoGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text('sunyata',
                          style: TextStyle(
                              color: JuntoPalette.juntoGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ]),
        );
  }
}