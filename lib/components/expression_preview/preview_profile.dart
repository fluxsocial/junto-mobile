import 'package:flutter/material.dart';
import '../../typography/style.dart';
import '../../custom_icons.dart';

class PreviewProfile extends StatelessWidget {
  final String handle;

  PreviewProfile(this.handle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            
            // profile picture
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__eric.png',
                height: 36.0,
                width: 36.0,
                fit: BoxFit.cover,
              ),
            ),

            // profile name and handle
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Eric Yang',
                    style: JuntoStyles.expressionPreviewName,
                  ),
                  Text(handle, style: JuntoStyles.expressionPreviewHandle)
                ],
              ),
            ),
          ]),
          Row(children: [
            // Text(time, style: TextStyle(fontSize: 12)),
            // more option on expression preview
            Container(child: Icon(CustomIcons.more, size: 17))
          ])
        ],
      ),
    );
  }
}
