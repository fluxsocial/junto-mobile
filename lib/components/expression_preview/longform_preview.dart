
import 'package:flutter/material.dart';

import './../../theme.dart';

class LongformPreview extends StatelessWidget {
  var title;
  var body;

  LongformPreview(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
    Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600, color: JuntoTheme.juntoGrey),
            ),
          ),
          
          Text(
            body,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: JuntoTheme.juntoGrey),
          ),
        ],
      ),
    );
  }
}
