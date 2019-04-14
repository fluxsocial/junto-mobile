
import 'package:flutter/material.dart';

import './channel_preview.dart';

class PreviewBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: <Widget>[
          ChannelPreview(),
          ChannelPreview(),
          ChannelPreview(),

        ],
      ),
    );
  }
}
