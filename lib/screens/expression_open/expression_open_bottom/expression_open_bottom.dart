
import 'package:flutter/material.dart';

import '../../../custom_icons.dart';
import './../expression_open_channel/expression_open_channel.dart';

class ExpressionOpenBottom extends StatelessWidget {

  final String channelOne;
  final String channelTwo;
  final String channelThree;
  final String time;

  ExpressionOpenBottom({this.channelOne, this.channelTwo, this.channelThree, this.time});

  _buildChannels() {
    if (channelOne == '' && channelTwo == '' && channelThree == '') {
      return Container(
        height: 0,
        width: 0
      );
    } else {
      return 
        Container(
          margin: EdgeInsets.only(bottom: 2.5),
          child: 
            Row(
              children: <Widget>[
                ExpressionOpenChannel(channelOne),
                ExpressionOpenChannel(channelTwo),
                ExpressionOpenChannel(channelThree)
              ],
            ),
        );
    }
  }
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
                    _buildChannels(),

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