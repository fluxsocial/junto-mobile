import 'dart:convert';
import 'package:flutter/material.dart';

import '../../typography/palette.dart';
import 'package:http/http.dart' as http;

// This widget is enables the user to add channels and create an expression.
// Rendered within each expression type.
class CreateActions extends StatefulWidget {
  // receive data schema from expression type
  final Map expression;
  CreateActions(this.expression);

  @override
  State<StatefulWidget> createState() {
    return CreateActionsState();
  }
}

// State class for CreateActions
class CreateActionsState extends State<CreateActions> {
  final List _channels = [];
  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffeeeeee), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(
            onTap: () {
              // open showBottomModalSheet widget
              _buildChannelsModal(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .5 - 10,
              child: Text('# CHANNELS',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xff333333))),
              alignment: Alignment.center,
            )),
        GestureDetector(
            onTap: () async {
              // Holochain API address
              String _url = 'http://127.0.0.1:8888';

              // Headers
              Map<String, String> _headers = {
                "Content-type": "application/json"
              };

              // JSON body
              final body =
                  '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "expression", "function": "post_expression", "args": {"expression": {"expression_type": "LongForm", "expression": {"LongForm": {"title": "The Medium is the Message", "body": "Hellos"}}}, "attributes": [], "context": ["Qmf42ZrmheTZugJsTXsCb7miRPGQjSReFrHNUQRzm9E7Y3"]}}}';
                  // '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "config", "function": "update_bit_prefix", "args": {"bit_prefix": 1}}}';
                  // '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "expression", "function": "get_expression", "args": {"expression": "QmNQpXckvU3w49B35xxxikcGzXamQM6FVj8BXgjsA9V4FM"}}}';

              // Retrieve response from create_user function
              http.Response response =  
                  await http.post(_url, headers: _headers, body: body);

              // Generate status code of response
              int createUserStatus = response.statusCode;

              print(createUserStatus);

              // Decode and store JSON from reponse.body
              final createUserResponse = json.decode(response.body);

              print(createUserResponse);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .5 - 10,
              child: Text('CREATE',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xff333333))),
              alignment: Alignment.center,
            )),
      ]),
    );
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
              height: MediaQuery.of(context).size.height * .4,
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
        print(widget.expression['tags']);
        widget.expression['tags'] = _channels;
        print(widget.expression);
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
}

            // Firebase 
          
            // onTap: () {
            //   // update expression's channels to the ones the user adds via modal
            //   widget.expression['tags'] = _channels;
            //   // send http request
            //   http
            //       .post('https://junto-b48dd.firebaseio.com/expressions.json',
            //           body: json.encode(widget.expression))
            //       .then((http.Response response) {
            //     final Map<String, dynamic> responseData =
            //         json.decode(response.body);
            //     print(responseData);
            //   });
            //   print('successfully created post');
            // },