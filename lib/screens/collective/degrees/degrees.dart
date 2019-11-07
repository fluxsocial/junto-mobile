import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/degrees/degree/degree.dart';
import 'package:junto_beta_mobile/app/palette.dart';

/// Degrees of Separation widget rendered in Collective screen under 'JUNTO'
/// perspective
class DegreesOfSeparation extends StatelessWidget {
  const DegreesOfSeparation(
    this.changeDegree,
    this.colorOne,
    this.colorTwo,
    this.colorThree,
    this.colorFour,
    this.colorFive,
    this.colorSix,
  );

  final Function changeDegree;
  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;
  final Color colorFour;
  final Color colorFive;
  final Color colorSix;

  @override
  Widget build(BuildContext context) {
    return Container(
      // This padding is just a placeholder for demo
      color: Colors.white,
      foregroundDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: JuntoPalette.juntoFade,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Degree('one', changeDegree, colorOne),
                Degree('two', changeDegree, colorTwo),
                Degree('three', changeDegree, colorThree),
                Degree('four', changeDegree, colorFour),
                Degree('five', changeDegree, colorFive),
                Degree('six', changeDegree, colorSix),
              ],
            ),
          )
        ],
      ),
    );
  }
}
