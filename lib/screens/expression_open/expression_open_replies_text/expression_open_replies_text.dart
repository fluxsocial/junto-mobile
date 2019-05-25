
import 'package:flutter/material.dart';

class ExpressionOpenRepliesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            )
          )
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text('CONVERSATIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),

        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            )
          )
        ),            
      ],)
    );
  }
}