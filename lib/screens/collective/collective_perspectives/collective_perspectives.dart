
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

class CollectivePerspectives extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Container(
        height: 75.0,
        color: JuntoPalette.juntoWhite,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Collective',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),                      

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/perspectives');
                },
                child:Icon(Icons.keyboard_arrow_right, color: JuntoPalette.juntoSleek, size: 17)
              ),
            ]),
      );    
  }
}