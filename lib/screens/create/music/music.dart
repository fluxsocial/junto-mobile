
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

// import 'package:webview_flutter/webview_flutter.dart';

class CreateMusic extends StatefulWidget {
  // WebViewController _controller;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateMusicState();
  }

}



class CreateMusicState extends State<CreateMusic> {
  final myController = TextEditingController();

  getExpressions() {
    http.get('https://junto-b48dd.firebaseio.com/expressions.json')
      .then((http.Response response) {
        print(json.decode(response.body));
      });
  }

  @override
  void initState() {
    getExpressions();
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text('placeholder')      
    );

      // Container(
      //   height: 500,
      //   child: WebView(
      //         initialUrl: 'https://junto.foundation',
      //         onWebViewCreated: (WebViewController webViewController) {
      //           _controller = webViewController;
      //         },
      //         javascriptMode: JavascriptMode.unrestricted
      // ));
  }
}