import 'dart:convert';
import 'package:flutter/material.dart';

import '../../typography/style.dart';
import 'package:http/http.dart' as http;

class CreateActions extends StatelessWidget {
  final expression;

  CreateActions(this.expression);

  @override
  Widget build(BuildContext context) {
    return 
      GestureDetector(
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(
                  onTap: () {
                    print(expression);
                  },                  
                  child: 
                    Container(
                      width: MediaQuery.of(context).size.width * .5 - 10,
                      child: Text('# CHANNELS', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff333333))),
                      alignment: Alignment.center,
                    )                  
                ),

                GestureDetector(
                  onTap: () {

                    http.post('https://junto-b48dd.firebaseio.com/expressions.json', 
                    body: json.encode(expression)).then((http.Response response) {
                      final Map<String, dynamic> responseData = json.decode(response.body);
                      print(responseData);
                      // return ;  
                    });
                    print('successfully created post');
                  },
                  child: 
                  Container(
                    width: MediaQuery.of(context).size.width * .5 - 10,
                    child: Text('CREATE', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff333333))),
                    alignment: Alignment.center,
                  )
                ),                
          ]),
        ),
      );
  }
}
