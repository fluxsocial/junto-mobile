import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';
import '../../../custom_icons.dart';

import './create_actions_appbar/create_actions_appbar.dart';

class CreateActions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateActionsState();
  }
}

class CreateActionsState extends State<CreateActions> {
  final List _channels = [];

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45), child: CreateActionsAppbar()),
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _buildChannelsModal(context);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffeeeeee), width: 1))),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text('add channels')),
            ),
            GestureDetector(
              onTap: () {
                _buildLayersModal(context);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffeeeeee), width: 1))),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text("sharing to collective")),
            ),
          ],
        ));
  }

  // Build bottom modal to add channels to expression
  _buildChannelsModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // Use StatefulBuilder to pass state of CreateActions
          return StatefulBuilder(builder: (context, state) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextField(
                          controller: _channelController,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '# add up to three channels',
                          ),
                          cursorColor: JuntoPalette.juntoGrey,
                          cursorWidth: 2,
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          maxLength: 80,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            // Update channels list in state until there are 3
                            _channels.length < 3
                                ? _updateChannels(
                                    state, _channelController.text)
                                : _nullChannels();
                          },
                          child: Text(
                            'add',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff333333), width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: _channels.length == 0
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _channels.length == 0
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'DOUBLE TAP TO REMOVE CHANNEL',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                      Wrap(
                          runSpacing: 5,
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: _channels
                              .map(
                                (channel) => GestureDetector(
                                      onDoubleTap: () {
                                        _removeChannel(state, channel);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Color(0xff333333),
                                                width: 1)),
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          channel,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                              )
                              .toList()),
                    ],
                  ),
                ),
              ]),
            );
          });
        });
  }

  // Update the list of channels in state
  _updateChannels(StateSetter updateState, channel) async {
    updateState(() {
      if (channel != '') {
        _channels.add(channel);

        _channelController.text = '';
      }
    });
  }

  // Remove a channel from the list of channels in state
  _removeChannel(StateSetter updateState, channel) async {
    updateState(() {
      _channels.remove(channel);
    });
  }

  // Called when channels.length > x
  _nullChannels() {
    return;
  }

  // Build bottom modal to add channels to expression
  _buildLayersModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // Use StatefulBuilder to pass state of CreateActions
          return StatefulBuilder(builder: (context, state) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .75,
                        color: Colors.white,
                        child: TextField(
                          controller: _channelController,
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'choose where to share your expression'),
                          cursorColor: JuntoPalette.juntoGrey,
                          cursorWidth: 2,
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          maxLength: 80,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                    ),
                  ),
                ),

              ]),
            );
          });
        });
  }
}
