
import 'package:flutter/material.dart';

class ShortformPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Text(
                  'Hello, my name is Eric. This is a shortform expression. This is one of many expressions that will exist in the Junto atmosphere.',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ); 
  }
}