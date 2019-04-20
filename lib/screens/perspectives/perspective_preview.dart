
import 'package:flutter/material.dart';

import '../../typography/style.dart';

class PerspectivePreview extends StatelessWidget {
  final String perspectiveName;

  PerspectivePreview(this.perspectiveName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: 75.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Color(0xffeeeeee)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(perspectiveName, style: JuntoStyles.perspectiveTitle)
            ],
        ));
  }
}
