
import 'package:flutter/material.dart';

import './channel_preview.dart';
import '../../custom_icons.dart';
import '../../typography/style.dart';
import '../../typography/palette.dart';

class PreviewBottom extends StatelessWidget {
  final expression;

  PreviewBottom(this.expression);

  _buildChannels() {
    List channels = expression.channels; 
    
    if (channels == []) {
      return SizedBox();
    } else {
      return 
        Container(
          margin: EdgeInsets.only(bottom: 2.5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.start, children: 
                channels.map((channel) => ChannelPreview(channel)).toList()

          ),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    String expressionTime = expression.timestamp; 
    return Container(
      margin: EdgeInsets.only(top: 7.5),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _buildChannels(),

              Container(
                  child: Text(
                expressionTime + ' MINUTES AGO',
                style: JuntoStyles.expressionPreviewTime,
                textAlign: TextAlign.start,
              ))
            ],
          )),

          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(CustomIcons.half_lotus, size: 15, color: JuntoPalette.juntoBlue)
          )      
        ],
      ),
    );
  }
}