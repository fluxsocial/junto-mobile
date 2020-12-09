import 'package:flutter/material.dart';

class SignUpBirthdayDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        '/',
        style: TextStyle(
          color: Colors.white.withOpacity(.7),
          fontSize: 20,
        ),
      ),
    );
  }
}
