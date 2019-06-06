import 'package:flutter/material.dart';

import './degree/degree.dart';

class DegreesOfSeparation extends StatelessWidget {
  Function changeDegree;
  final colorInfinity;
  final colorOne;
  final colorTwo;
  final colorThree;
  final colorFour;
  final colorFive;
  final colorSix;

  DegreesOfSeparation(
      this.changeDegree,
      this.colorInfinity,
      this.colorOne,
      this.colorTwo,
      this.colorThree,
      this.colorFour,
      this.colorFive,
      this.colorSix
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: .5, color: Color(0xffeeeeee)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, ),
                margin: EdgeInsets.only(top: 15),
                child: Text('Degrees of Separation'.toUpperCase(),                    
                    style: TextStyle(                      
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1),),),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Degree('infinity', changeDegree, colorInfinity),
                    Degree('one', changeDegree, colorOne),
                    Degree('two', changeDegree, colorTwo),
                    Degree('three', changeDegree, colorThree),
                    Degree('four', changeDegree, colorFour),
                    Degree('five', changeDegree, colorFive),
                    Degree('six', changeDegree, colorSix),
                  ],
                )              
            )                        
          ],
        ));
  }
}
