
import 'package:flutter/material.dart';

import '../../../../typography/palette.dart';
import '../../../../custom_icons.dart';

class PackOpenFAB extends StatelessWidget {
  final isVisible;

  PackOpenFAB(this.isVisible);
  
  @override
  Widget build(BuildContext context) {
    return 
      AnimatedOpacity(                                      
        duration: Duration(milliseconds: 200),          
        opacity: isVisible ? 1 : 0,
        child:       
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(color: Color(0xffeeeeee), width: .5),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff999999),
                  blurRadius: 3,
                  offset: Offset(1, 2),
                )
              ],
            ),
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            // padding: EdgeInsets.symmetric(vertical: 15),
            height: 50,
            width: MediaQuery.of(context).size.width * .75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(                
                  width: MediaQuery.of(context).size.width * .37,
                  child: Icon(CustomIcons.half_lotus, size: 17, color: JuntoPalette.juntoGrey),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .37,
                  child:
                    RotatedBox(
                      quarterTurns: 2,
                      child: Icon(CustomIcons.triangle, size: 17, color: JuntoPalette.juntoGrey)
                    )
                )            
            ],)
          )
        );    
  }
}