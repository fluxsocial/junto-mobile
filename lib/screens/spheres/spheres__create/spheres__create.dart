
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

class SpheresCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Create a Sphere', style: TextStyle(color: JuntoPalette.juntoGrey, fontSize: 14, fontWeight: FontWeight.w700)),
            Container(
              child: Icon(Icons.add_circle_outline, size: 17, color: JuntoPalette.juntoGrey)
            )
          ])
      ); 
  }
}