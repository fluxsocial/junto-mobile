import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';

class JuntoChannels extends StatefulWidget {
  const JuntoChannels({this.currentPerspective});

  final String currentPerspective;
  @override
  State<StatefulWidget> createState() {
    return JuntoChannelsState();
  }
}

class JuntoChannelsState extends State<JuntoChannels> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 80,
              color: Theme.of(context).backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image.asset('assets/images/junto-mobile__binoculars.png',
                      height: 17, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    widget.currentPerspective,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              color: Theme.of(context).backgroundColor,
              // color: Colors.green,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0.0, 10.0),
                      child: TextField(
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0.0),
                          hintText: 'filter by channel',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 1,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //   height: 50,
            //   color: Theme.of(context).backgroundColor,
            //   child: Row(
            //     children: <Widget>[
            //       Icon(CustomIcons.packs, size: 17),
            //       SizedBox(width: 10),
            //       Text(
            //         'JUNTO',
            //         style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500,
            //             color: Theme.of(context).primaryColor),
            //       )
            //     ],
            //   ),
            // ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  const ChannelPreview(channel: 'regenerative agriculture'),
                  const ChannelPreview(channel: 'food'),
                  const ChannelPreview(channel: 'biomimicry'),
                  const ChannelPreview(channel: 'austrian economics'),
                  const ChannelPreview(channel: 'conscious tech'),
                  const ChannelPreview(channel: 'implementation next build'),
                ],
              ),
            ),
          ]),
    );
  }
}
