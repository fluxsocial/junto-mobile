
import 'package:flutter/material.dart';

class DegreesOfSeparation extends StatelessWidget {
  Function changeDegree;
  final colorInfinity;
  final colorOne;
  final colorTwo;
  final colorThree;
  final colorFour;
  final colorFive;
  final colorSix;

  DegreesOfSeparation(this.changeDegree, this.colorInfinity, this.colorOne, this.colorTwo, this.colorThree, this.colorFour, this.colorFive, this.colorSix);

  @override
  Widget build(BuildContext context) {
    
    return 
      Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          color: Colors.white,
          foregroundDecoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: Text('DEGREES OF SEPARATION', style: TextStyle(color: Color(0xff333333), fontWeight: FontWeight.w700))
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      changeDegree('infinity');
                    },
                    child: Container(
                        child: Text('oo',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorInfinity,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('one');
                    },
                    child: Container(
                        child: Text('i',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorOne,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('two');
                    },
                    child: Container(
                        child: Text('ii',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorTwo,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('three');
                    },
                    child: Container(
                        child: Text('iii',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorThree,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('four');
                    },
                    child: Container(
                        child: Text('iv',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorFour,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('five');

                    },
                    child: Container(
                        child: Text('v',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorFive,
                            ))),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDegree('six');
                    },
                    child: Container(
                        child: Text('vi',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: colorSix,
                            ))),
                  ),
                ],
              )
            ],
          ));

  }

}