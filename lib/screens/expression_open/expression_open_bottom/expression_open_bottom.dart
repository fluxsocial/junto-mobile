
import 'package:flutter/material.dart';

import '../../../custom_icons.dart';
import './../expression_open_channel/expression_open_channel.dart';

class ExpressionOpenBottom extends StatefulWidget {
  final channels;
  final String time;

  ExpressionOpenBottom({this.channels, this.time});

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenBottomState();
  }
}

class ExpressionOpenBottomState extends State<ExpressionOpenBottom> {
  String _channelOne;
  String _channelTwo;
  String _channelThree;

  @override
  void initState() {
    if(widget.channels == null) {
      return;
    } else if (widget.channels.length == 1) {
      _channelOne = widget.channels[0];
    } else if (widget.channels.length == 2 ) {
      _channelOne = widget.channels[0];
      _channelTwo = widget.channels[1];      
    } else if(widget.channels.length == 3) {
      _channelOne = widget.channels[0];
      _channelTwo = widget.channels[1];
      _channelThree = widget.channels[2];
    }
    
    super.initState();
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
              children: [        
                _buildChannels(),

                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(CustomIcons.half_lotus, size: 15)
                )
              ]
            ));  
  }

  _buildChannels() {
    if (widget.channels == null) {
      return Container(height: 0, width: 0);
    } else {
      return 
        Container(
          margin: EdgeInsets.only(bottom: 2.5),
          child: 
            Row(
              children: [
                _buildChannel(_channelOne),                
                _channelTwo != null ? _buildChannel(_channelTwo) : SizedBox(),
                _channelThree != null ? _buildChannel(_channelThree) : SizedBox()
              ]
            ),
        );      
    }
  }      

  _buildChannel(channel) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Text('#' + channel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
      );      
  }
}
