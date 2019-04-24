
import 'package:flutter/material.dart';

import './../../typography/palette.dart';
import './../../typography/style.dart';

class ChannelPreview extends StatelessWidget {
  final String channel;

  ChannelPreview(this.channel);

  _buildChannel() {
    if (channel == '') {
      return Container(
        height: 0,
        width: 0
      );
    } else {
      return 
        Text(
          '#' + channel,
          style: JuntoStyles.expressionPreviewChannel,
        );   
    }
  }
  @override
  Widget build(BuildContext context) {

    return Container(
          margin: EdgeInsets.only(right: 5.0),
          child: _buildChannel()
        );    
  }
}
