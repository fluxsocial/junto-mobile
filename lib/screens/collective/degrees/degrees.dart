import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

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
      this.colorSix);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                margin: EdgeInsets.only(bottom: 7.5),
                child: Text('DEGREES OF SEPARATION',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    changeDegree('infinity');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorInfinity == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('oo',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorInfinity
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('one');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorOne == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('i',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorOne
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('two');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorTwo == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('ii',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorTwo
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('three');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorThree == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('iii',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorThree
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('four');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorFour == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('iv',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorFour
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('five');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorFive == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('v',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorFive
                          ))),
                ),
                GestureDetector(
                  onTap: () {
                    changeDegree('six');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: colorSix == Color(0xffffffff)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [
                                    0.1,
                                    0.9
                                  ],
                                  colors: [
                                    JuntoPalette.juntoPurple,
                                    JuntoPalette.juntoBlue
                                  ]))
                          : null,
                      child: Text('vi',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colorSix
                          ))),
                ),
              ],
            )
          ],
        ));
  }
}
