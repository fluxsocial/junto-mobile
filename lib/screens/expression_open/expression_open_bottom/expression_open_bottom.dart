
import 'package:flutter/material.dart';

import '../../../custom_icons.dart';

class ExpressionOpenBottom extends StatelessWidget {

  final String channelOne;
  final String channelTwo;
  final String channelThree;
  final String time;

  ExpressionOpenBottom({this.channelOne, this.channelTwo, this.channelThree, this.time});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
        Container(
            margin: EdgeInsets.symmetric(vertical: 7.5),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: Color(0xffeeeeee), width: 1.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text('#' + channelOne,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text('#' + channelTwo,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Text('#' + channelThree,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    Text(time,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff555555)))
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(CustomIcons.resonate),
                    ),
                    Icon(CustomIcons.comment)
                  ],
                )
              ],
            ));  
  }
}