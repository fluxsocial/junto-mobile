import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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
