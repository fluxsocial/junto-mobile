
import 'package:flutter/material.dart';

import './../../theme.dart';

class ChannelPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: JuntoTheme.juntoGrey),
        borderRadius: BorderRadius.all(
          Radius.circular(2),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 6.0),
      child: Text(
        'channel one',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: JuntoTheme.juntoGrey),
      ),
    );
  }
}
