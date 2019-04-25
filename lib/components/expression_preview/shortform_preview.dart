
import 'package:flutter/material.dart';

class ShortformPreview extends StatelessWidget {
  final String _shortformText;

  ShortformPreview(this._shortformText);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.9],
                colors: [
                  Color(0xff5E54D0),
                  Color(0xff307FAB)
                ]
              )
            ),

            constraints: BoxConstraints(
                minHeight: 240,
            ),
            width: 1000,
            // color: Colors.lightBlue,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Text(
                  _shortformText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ); 
  }
}