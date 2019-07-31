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
  String _expressionLayer;

  final List _channels = [];
  bool showLayers = false;
  String expressionContext;
  String jsonBody;
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
            onTap: () {
              _buildLayersModal(context);
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

  _buildLayersModal(context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[   
                Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text('Choose where to send your expression', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))
                  ),

                  GestureDetector(
                    onTap: () {
                      _selectLayer(state, 'collective');
                    },                    
                    child: 
                      Container(
                        color: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(100)
                              ),
                            ),
                            Text('COLLECTIVE')                
                        ],)
                      ),                    
                  ),

                  GestureDetector(
                    onTap: () {
                      _selectLayer(state, 'pack');
                    },
                    child: 
                      Container(
                        color: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(100)
                              ),
                            ),
                            Text('PACK')                    

                        ],)
                      ),                    
                  ),        

                  GestureDetector(
                    onTap: () {
                      _selectLayer(state, 'den');
                    },                    
                    child: 
                      Container(
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(100)
                              ),
                            ),
                            Text('DEN')                    
                        ],)
                      ),                    
                  ),                                    
                ],),
       
                        Container(
                          width: 200,                           
                          decoration: 
                              BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [0.1, 0.9],
                                    colors: [
                                      Color(0xff5E54D0),
                                      Color(0xff307FAB)
                                    ]
                                  ),
                                  borderRadius: BorderRadius.circular(100)
                                ),                          
                          child:                            
                            RaisedButton(                                        
                              onPressed: () {
                                _createExpression();
                              },        
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20
                              ),    
                              color: Colors.transparent,
                              elevation: 0,
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              child: 
                                Text('CREATE', 
                                  style: TextStyle(
                                    // color: JuntoPalette.juntoBlue, 
                                    color: Colors.white, 
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14)),
                              )                                                                                        
                                
                      )                                             
            ],)
          );
        });
      });            
  }

    _selectLayer(updateState, layer) {
      
      if(layer == 'collective') {
        setState(() {
          _expressionLayer = 'collective';    
          print(_expressionLayer);
        });
      } else if(layer == 'pack') {
        setState(() {
          _expressionLayer = 'pack';  
          print(_expressionLayer);

        });        

      } else if(layer == 'den') {
        setState(() {
          _expressionLayer = 'den';   
          print(_expressionLayer);
        });        
      }    
  }      

    _createExpression() async {
      // Holochain API address
      String _url = 'http://127.0.0.1:8888';

      // Headers
      Map<String, String> _headers = {
        "Content-type": "application/json"
      }; 

      // Set expression context (where post is going to be sent)
      setState(() {
        if(_expressionLayer == 'collective') {
          expressionContext = 'Qmf42ZrmheTZugJsTXsCb7miRPGQjSReFrHNUQRzm9E7Y3';
        } else if(_expressionLayer =='pack') {
          expressionContext = '';
        }
      });

      // Generate proper JSON for expression
      if(widget.expression['expression_type'] == 'LongForm') {
        setState(() {
          jsonBody = '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "expression", "function": "post_expression", "args": {"expression": {"expression_type": "LongForm", "expression": {"LongForm": {"title": "' + widget.expression['title'] + '", "body": "' + widget.expression['body'] + '"}}}, "attributes": ["' + _channels.toString() + '"], "context": ["' + expressionContext + '"]}}}';                
        });                
      } else if (widget.expression['expression_type'] == 'Shortform') {
        return ;
      }

      // Retrieve response from post_expression function
      http.Response response = await http.post(_url, headers: _headers, body: jsonBody);

      // Decode and store JSON from reponse.body
      final postExpressionResponse = json.decode(response.body);
      print(postExpressionResponse);      


    }
  }

    // '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "config", "function": "update_bit_prefix", "args": {"bit_prefix": 1}}}';
    // final body = '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "expression", "function": "get_expression", "args": {"expression": "QmQVHujoCjR3bpErTBQUdRDfAi1fmMEt5aMZbrUfFYMwNy"}}}';




            // onTap: () async {
            //   // Holochain API address
            //   String _url = 'http://127.0.0.1:8888';

            //   // Headers
            //   Map<String, String> _headers = {
            //     "Content-type": "application/json"
            //   }; 

            //   // Set expression context (where post is going to be sent)
            //   setState(() {
            //     expressionContext = 'Qmf42ZrmheTZugJsTXsCb7miRPGQjSReFrHNUQRzm9E7Y3';
            //   });

            //   // Generate proper JSON for expression
            //   if(widget.expression['expression_type'] == 'LongForm') {
            //     setState(() {
            //       jsonBody = '{"jsonrpc":"2.0", "id": "0", "method": "call", "params": {"instance_id":"test-instance", "zome": "expression", "function": "post_expression", "args": {"expression": {"expression_type": "LongForm", "expression": {"LongForm": {"title": "' + widget.expression['title'] + '", "body": "' + widget.expression['body'] + '"}}}, "attributes": ["' + _channels.toString() + '"], "context": ["' + expressionContext + '"]}}}';                
            //     });                
            //   } else if (widget.expression['expression_type'] == 'Shortform') {
            //     return ;
            //   }

            //   // Retrieve response from post_expression function
            //   http.Response response = await http.post(_url, headers: _headers, body: jsonBody);

            //   // Decode and store JSON from reponse.body
            //   final postExpressionResponse = json.decode(response.body);
            //   print(postExpressionResponse);
            // },