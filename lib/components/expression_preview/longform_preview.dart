
import 'package:flutter/material.dart';

class LongformPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('The Medium is the Message', textAlign: TextAlign.left),
            Text('Hallos, my name is Urk and I am a dogie',
                textAlign: TextAlign.right)
          ],
        ),
      );     
  }
}