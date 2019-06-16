
import 'package:flutter/material.dart';

class ExpressionOpenChannel extends StatelessWidget {
  final String channel;

  ExpressionOpenChannel(this.channel);

  _buildChannel() {
    if (channel == '') {
      return Container(
        width: 0,
        height: 0
      );
    } else {
      return 
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text('#' + channel,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        );      
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      _buildChannel();
  }
}