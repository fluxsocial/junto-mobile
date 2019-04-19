
import 'package:flutter/material.dart';

import '../../style.dart';

class PerspectiveTemplate extends StatelessWidget {
  final String perspectiveName;

  PerspectiveTemplate(this.perspectiveName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: 90.0,
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
