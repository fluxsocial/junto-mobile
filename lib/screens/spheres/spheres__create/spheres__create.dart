
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

class SpheresCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Container(
        // height: 75,
        // margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   border: Border.all(color: Color(0xffeeeeee), width: 1 ),
        //   borderRadius: BorderRadius.circular(5),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Color(0xffeeeeee),
        //       blurRadius: 3,
        //       offset: Offset(1, 3),
        //       // spreadRadius: 5
        //     )
        // ],          
        // ),

      
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Create a Sphere', style: TextStyle(color: JuntoPalette.juntoGrey, fontSize: 17, fontWeight: FontWeight.w700)),
            Container(
              child: Icon(Icons.add_circle_outline, size: 17, color: JuntoPalette.juntoGrey)
            )
          ])
      ); 
  }
}