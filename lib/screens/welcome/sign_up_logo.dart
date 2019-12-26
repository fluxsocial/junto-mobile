import 'package:flutter/material.dart';

class SignUpLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * .05,
        left: 20,
        child: Image.asset(
          'assets/images/junto-mobile__logo--white.png',
          height: 36,
        ));
  }
}
