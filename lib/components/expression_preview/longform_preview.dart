
import 'package:flutter/material.dart';

import './../../typography/palette.dart';

class LongformPreview extends StatelessWidget {
  final title;
  final body;

  LongformPreview(this.title, this.body);

  _buildTitle() {
    if(title != '') {
      return 
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: JuntoPalette.juntoGrey),
            ),
          );     
    } else {
      return Container(
        height: 0,
        width: 0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          _buildTitle(),
    
          Text(
            body,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: JuntoPalette.juntoGrey),
          ),
        ],
      ),
    );
  }
}