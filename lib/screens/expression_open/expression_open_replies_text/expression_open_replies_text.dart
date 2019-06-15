
import 'package:flutter/material.dart';

import '../../../custom_icons.dart';

class ExpressionOpenRepliesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: <Widget>[

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
            )
          ),
          child: Row(children: <Widget>[
            Text('VIEW REPLIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down, size: 17, color: Color(0xff555555))
          ],)                            
          ),
      
      ],)
    );
  }
}