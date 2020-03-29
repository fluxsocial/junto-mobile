import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    Key key,
    this.source,
    this.navigateTo,
  }) : super(key: key);

  final ExpressionType source;
  final Function navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (source == null || source == true) {
          Navigator.pop(context);
        } else {
          navigateTo(context, source);
        }
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        height: 50,
        width: 100,
        child: RotatedBox(
          quarterTurns: 2,
          child: Icon(
            CustomIcons.newdoubleuparrow,
            size: 45,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
