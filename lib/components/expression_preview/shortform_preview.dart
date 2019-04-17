
import 'package:flutter/material.dart';

class ShortformPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'This is a shortform expression',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                  ),
                ),
                
                Text(
                  'Hello, my name is Eric',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ); 
  }
}