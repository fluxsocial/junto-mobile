import 'package:flutter/material.dart';

class ExpressionOpenChannel extends StatelessWidget {
  const ExpressionOpenChannel(this.channel);

  final String channel;

  Widget _buildChannel() {
    if (channel == '') {
      return Container(width: 0, height: 0);
    } else {
      return Container(
        margin: const EdgeInsets.only(right: 5),
        child: Text(
          '#' + channel,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildChannel();
  }
}
