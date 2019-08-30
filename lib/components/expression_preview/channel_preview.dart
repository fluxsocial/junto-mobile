import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/style.dart';

class ChannelPreview extends StatelessWidget {
  const ChannelPreview({
    Key key,
    this.channel,
  }) : super(key: key);

  final String channel;

  Widget _buildChannel() {
    if (channel == '') {
      return Container(height: 0, width: 0);
    } else {
      return Container(
        margin: const EdgeInsets.only(right: 5.0),
        child: Text(
          '#' + channel,
          style: JuntoStyles.expressionPreviewChannel,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildChannel();
  }
}
