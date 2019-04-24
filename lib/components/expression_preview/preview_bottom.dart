
import 'package:flutter/material.dart';

import './channel_preview.dart';
import '../../custom_icons.dart';

class PreviewBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
           child: Row(
             children: [
              ChannelPreview(),
              ChannelPreview(),
              ChannelPreview(),
             ]),
          ),
          
          Container(
            alignment: Alignment.center,
            child: Row(children: [
              Icon(CustomIcons.resonate, size: 20),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Icon(CustomIcons.comment, size: 20)
              ),

            ])
          )


        ],
      ),
    );
  }
}
