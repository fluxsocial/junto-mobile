
import 'package:flutter/material.dart';

import './../../typography/palette.dart';
import './../../typography/style.dart';

class LongformPreview extends StatelessWidget {
  final title;
  final body;

  LongformPreview(this.title, this.body);

  _buildTitle() {
    if(title != '') {
      return 
          Container(
            margin: EdgeInsets.only(bottom: 2.5),
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: JuntoStyles.longformTitle,
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
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          _buildTitle(),
    
          Text(
            body,
            textAlign: TextAlign.left,
            style: JuntoStyles.longformBody,
          ),
        ],
      ),
    );
  }
}