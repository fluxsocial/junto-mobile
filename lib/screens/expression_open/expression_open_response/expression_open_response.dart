
import 'package:flutter/material.dart';

class ExpressionOpenResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
          Container(            
            child: Row(children: [
              Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.comment)),
              // Text('RESPOND')
            ])
          ),

          Container(            
            child: Row(children: [
              Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.comment)),
              // Text('RESONATE')
            ])
          ),
          
        ])
      );
  }
}