import 'package:flutter/material.dart';

class JuntoLogo extends StatelessWidget {
  const JuntoLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Image.asset(
        'assets/images/junto-mobile__outlinelogo--gradient.png',
        height: 69,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
