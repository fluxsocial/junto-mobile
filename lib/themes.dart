import 'package:flutter/material.dart';

class JuntoThemes {
  final ThemeData juntoLightTheme = ThemeData(
    fontFamily: 'Avenir',
    primaryColor: const Color(0xFF307FAB),
    primaryColorLight: const Color(0xFF5EB6D5),
    accentColor: const Color(0xff5E54D0),
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(
        color: const Color(0xff555555),
        fontSize: 17,
        letterSpacing: .5,
        fontWeight: FontWeight.w700,
      ),
      subtitle: TextStyle(
        color: const Color(0xff333333),
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
      body1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
