import 'dart:convert';
import 'package:flutter/material.dart';

import '../../typography/palette.dart';
import '../../typography/style.dart';
import 'package:http/http.dart' as http;

class CreateActions extends StatefulWidget {
  final expression;

  CreateActions(this.expression);

  @override
  State<StatefulWidget> createState() {
    return CreateActionsState();
  }
}

class CreateActionsState extends State<CreateActions> {
  final _channels = [];
  String _channelOne;
  String _channelTwo;
  String _channelThree;

  @override
  void initState() {
    print(widget.expression['tags']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.blue,
            border:
                Border(top: BorderSide(color: Color(0xffeeeeee), width: 1))),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(
              onTap: () {
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
              onTap: () {
                http
                    .post('https://junto-b48dd.firebaseio.com/expressions.json',
                        body: json.encode(widget.expression))
                    .then((http.Response response) {
                  final Map<String, dynamic> responseData =
                      json.decode(response.body);
                  print(responseData);
                  // return ;
                });
                print('successfully created post');
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .5 - 10,
                child: Text('CREATE',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xff333333))),
                alignment: Alignment.center,
              )),
        ]),
      ),
    );
  }

  _buildChannelsModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return 
          StatefulBuilder(
            builder: (context, state) { 
              return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100),
                      topLeft: Radius.circular(100))),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width * .75,
                      child: TextField(
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
                              updated(state, 'yeo');
                              // print(_channels);
                            },
                            child: Text('add',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff333333)))),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff333333), width: 1),
                            borderRadius: BorderRadius.circular(5)))
                  ],
                ),
                Expanded(
                    child: ListView(
                  children: <Widget>[

                    ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: _channels.map((channel) => Text(channel)).toList()),
                    Container(height: 50, color: Colors.purple),
                    Container(height: 50, color: Colors.blue),
                    Container(height: 50, color: Colors.yellow),
                  ],
                ))
              ]));
        });
        });
  }

  updated(StateSetter updateState, channel) async {
    updateState(() {
      _channels.add(channel);
    });
  }


  
}
