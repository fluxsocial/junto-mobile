import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class PackOpenFAB extends StatelessWidget {
  const PackOpenFAB(this.isVisible);

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: isVisible ? 1 : 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Color(0xffeeeeee), width: .5),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0xff999999),
              blurRadius: 3,
              offset: Offset(1, 2),
            )
          ],
        ),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        // padding: EdgeInsets.symmetric(vertical: 15),
        height: 50,
        width: MediaQuery.of(context).size.width * .5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .25,
              child: Icon(
                CustomIcons.half_lotus,
                size: 17,
                color: JuntoPalette.juntoGrey,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .25,
              child: RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  CustomIcons.triangle,
                  size: 17,
                  color: JuntoPalette.juntoGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
