import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';

enum ListType { mention, channels, empty }

class ChannelsSearchList extends StatelessWidget {
  const ChannelsSearchList({
    this.channels,
    this.onChannelAdd,
  });

  final List<Map<String, dynamic>> channels;
  final Function onChannelAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .3,
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: channels.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          print(channels[index]);
          return InkWell(
            onTap: () {
              onChannelAdd(index);
            },
            child: ChannelPreview(
              channel: Channel(
                name: channels[index]['id'],
              ),
            ),
          );
        },
      ),
    );
  }
}
