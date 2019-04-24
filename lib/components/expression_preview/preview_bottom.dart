
import 'package:flutter/material.dart';

import './channel_preview.dart';
import '../../custom_icons.dart';
import '../../typography/style.dart';

class PreviewBottom extends StatelessWidget {
  final String time;

  PreviewBottom(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 2.5),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  ChannelPreview(),
                  ChannelPreview(),
                  ChannelPreview(),
                ]),
              ),
              Container(
                  child: Text(
                time + ' MINUTES AGO',
                style: JuntoStyles.expressionPreviewTime,
                textAlign: TextAlign.start,
              ))
            ],
          )),
          Container(
              alignment: Alignment.center,
              child: Row(children: [
                Icon(CustomIcons.resonate, size: 24, color: Colors.black),
                Container(
                    margin: EdgeInsets.only(left: 17),
                    child: Icon(CustomIcons.comment,
                        size: 24, color: Colors.black)),
              ]))
        ],
      ),
    );
  }
}
