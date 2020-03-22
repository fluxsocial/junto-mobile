import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';

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
        height: 50,
        width: 50,
        child: Image.asset(
          'assets/images/junto-mobile__double-down-arrow.png',
          height: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
