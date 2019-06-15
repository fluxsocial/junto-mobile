
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
            width: MediaQuery.of(context).size.width * .5 - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.comment)),
              Text('RESPOND', style: TextStyle(fontSize: 12))
            ])
          ),

          Container(    
            width: MediaQuery.of(context).size.width * .5 - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.comment)),
              Text('RESONATE', style: TextStyle(fontSize: 12))
            ])
          ),
          
        ])
      );
  }
}