import 'package:flutter/material.dart';

class PreviewProfile extends StatelessWidget {
  final String handle;

  PreviewProfile(this.handle);
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
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
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
                  ),
                  Text('@' + handle, style: TextStyle(fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ]),

          // more option on expression preview
          Container(child: Icon(Icons.arrow_drop_down))
        ],
      ),
    );
  }
}
