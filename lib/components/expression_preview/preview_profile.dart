
import 'package:flutter/material.dart';

class PreviewProfile extends StatelessWidget {
  final String handle;

  PreviewProfile(this.handle);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__eric.png',
                  height: 60.0,
                  width: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: <Widget>[Text('Eric Yang'), Text('@' + handle)],
                ),
              ),
            ],
          ),
        );
  }

}