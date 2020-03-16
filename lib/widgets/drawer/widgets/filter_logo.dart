import 'package:flutter/material.dart';

class FilterLogo extends StatelessWidget {
  const FilterLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/junto-mobile__logo.png',
            color: Colors.white,
            height: 24,
          ),
        ],
      ),
    );
  }
}
