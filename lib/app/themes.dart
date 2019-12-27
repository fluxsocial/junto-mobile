import 'package:flutter/material.dart';

class JuntoThemes {
  // Junto Light Indigo Theme
  ThemeData juntoLightIndigo = ThemeData(
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    canvasColor: Colors.transparent,
    colorScheme: const ColorScheme(
        // Junto blue
        // primary: Color(0xff223E72),
        // primaryVariant: Color(0xFF223E72),
        primary: Color(0xff22517D),
        primaryVariant: Color(0xFF22517D),
        // Junto purple
        secondary: Color(0xFF635FAA),
        secondaryVariant: Color(0xFF635FAA),
        surface: Color(0xfff9f9f9),
        background: Colors.white,
        error: Color(0xff333333),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xff333333),
        onError: Color(0xff333333),
        onSurface: Color(0xff333333),
        brightness: Brightness.light),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        body1: TextStyle(
            color: const Color(0xff333333),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.02),
      ),
      iconTheme: const IconThemeData(color: Color(0xff333333), size: 22),
    ),
    bottomAppBarColor: Colors.blue,
    textTheme: TextTheme(
      display1: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xff333333),
      ),
      title: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xff333333),
      ),
      headline: TextStyle(
        fontSize: 17,
        color: const Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),

      // used for user and sphere handles
      subhead: TextStyle(
        fontSize: 15,
        color: const Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),

      subtitle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xff333333),
      ),

      body1: TextStyle(
        fontSize: 13,
        color: const Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      body2: TextStyle(
          color: const Color(0xff333333),
          fontSize: 14,
          fontWeight: FontWeight.w500),

      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: const Color(0xff333333),
      ),
      overline: TextStyle(
          fontSize: 12,
          color: const Color(0xff999999),
          fontWeight: FontWeight.w600,
          letterSpacing: .5),
    ),
  );

// Junto Night Indigo Theme
  ThemeData juntoNight = ThemeData(
    fontFamily: 'Avenir',
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    canvasColor: Colors.transparent,
    colorScheme: const ColorScheme(
        // Junto blue
        // primary: Color(0xFF223E72),
        primary: Color(0xff22517D),
        primaryVariant: Color(0xff222222),
        secondary: Color(0xFF635FAA),
        secondaryVariant: Color(0xff333333),
        surface: Color(0xff393939),
        background: Color(0xff333333),
        error: Color(0xff333333),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xff333333),
        onError: Color(0xff333333),
        onSurface: Color(0xff333333),
        brightness: Brightness.light),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: AppBarTheme(
      color: const Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        body1: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.02),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 22),
    ),
    bottomAppBarColor: Colors.blue,
    textTheme: TextTheme(
      display1: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      title: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subhead: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),

      subtitle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      body1: TextStyle(
        fontSize: 13,
        color: const Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      body2: TextStyle(
          color: const Color(0xfff0f0f0),
          fontSize: 14,
          fontWeight: FontWeight.w500),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: const Color(0xfff0f0f0),
      ),
      overline: TextStyle(
          fontSize: 12,
          color: const Color(0xffeeeeee),
          fontWeight: FontWeight.w600,
          letterSpacing: .5),
    ),
  );
}
