
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
    return 
        Container(
            margin: EdgeInsets.only(top: 7.5),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: Color(0xffeeeeee), width: .5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                _buildChannels(),

                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(CustomIcons.half_lotus, size: 15)
                )
              ],
            ));  
  }
}