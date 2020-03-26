import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class SelectedChannel extends StatelessWidget {
  const SelectedChannel({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: <SelectedChannelChip>[
          SelectedChannelChip(
            channel: channel.name,
          )
          // ...channels.map(
          //   (Channel e) => SelectedChannelChip(channel: e.name),
          // )
        ],
      ),
    );
  }
}

class SelectedChannelChip extends StatelessWidget {
  const SelectedChannelChip({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final String channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        channel,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}
