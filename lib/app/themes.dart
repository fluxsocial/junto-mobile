import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class JuntoThemes {
  ThemeData juntoLightMain = ThemeData(
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    colorScheme: ColorScheme(
        // Junto blue
        primary: const Color(0xFF307FAB),
        primaryVariant: const Color(0xff333333),
        // Junto purple
        secondary: const Color(0xFF635FAA),
        secondaryVariant: const Color(0xff333333),
        surface: const Color(0xfff9f9f9),
        background: Colors.white,
        error: const Color(0xff333333),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: const Color(0xff333333),
        onError: const Color(0xff333333),
        onSurface: const Color(0xff333333),
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
      title: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),

      subtitle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Color(0xff333333),
      ),

      // used for user and sphere handles
      subhead: TextStyle(
        fontSize: 15,
        color: const Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),

      body1: TextStyle(
        fontSize: 13,
        color: const Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      body2: TextStyle(
          color: Color(0xff333333), fontSize: 14, fontWeight: FontWeight.w500),

      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff333333),
      ),
      overline: TextStyle(
          fontSize: 12,
          color: Color(0xff999999),
          fontWeight: FontWeight.w600,
          letterSpacing: .5),
    ),
  );

  ThemeData juntoNight = ThemeData(
    fontFamily: 'Avenir',
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: Color(0xff333333),
    colorScheme: ColorScheme(
        // Junto blue
        primary: const Color(0xFF307FAB),
        primaryVariant: const Color(0xff333333),
        secondary: const Color(0xFF635FAA),
        secondaryVariant: const Color(0xff333333),
        surface: const Color(0xff393939),
        background: Color(0xff333333),
        error: const Color(0xff333333),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: const Color(0xff333333),
        onError: const Color(0xff333333),
        onSurface: const Color(0xff333333),
        brightness: Brightness.light),
    scaffoldBackgroundColor: Color(0xff333333),
    appBarTheme: AppBarTheme(
      color: Color(0xff333333),
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
      title: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      subtitle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      // used for user and sphere handles
      subhead: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      body1: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      body2: TextStyle(
          color: Color(0xfff0f0f0), fontSize: 14, fontWeight: FontWeight.w500),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
          fontSize: 12,
          color: const Color(0xffeeeeee),
          fontWeight: FontWeight.w600,
          letterSpacing: .5),
    ),
  );
}

// ThemeData juntoLightSecondary = ThemeData(
//   fontFamily: 'Avenir',
//   primaryColor: const Color(0xff555555),
//   primaryColorDark: const Color(0xff333333),
//   primaryColorLight: const Color(0xff999999),
//   dividerColor: const Color(0xffeeeeee),
//   backgroundColor: Colors.white,
//   colorScheme: ColorScheme(
//       // Junto
//       primary: Color(0xFFFFCF68),
//       // primary: const Color(0xFF635FAA),
//       primaryVariant: const Color(0xff333333),
//       // Junto purple
//       secondary: const Color(0xFF635FAA),
//       secondaryVariant: const Color(0xff333333),
//       surface: const Color(0xff333333),
//       background: Colors.white,
//       error: const Color(0xff333333),
//       onPrimary: Colors.white,
//       onSecondary: Colors.white,
//       onBackground: const Color(0xff333333),
//       onError: const Color(0xff333333),
//       onSurface: const Color(0xff333333),
//       brightness: Brightness.light),
//   scaffoldBackgroundColor: Colors.white,
//   appBarTheme: AppBarTheme(
//     color: Colors.white,
//     elevation: 0,
//     textTheme: TextTheme(
//       body1: TextStyle(
//           color: const Color(0xff333333),
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 1.02),
//     ),
//     iconTheme: const IconThemeData(color: Color(0xff333333), size: 22),
//   ),
//   bottomAppBarColor: Colors.blue,
//   textTheme: TextTheme(
//     // used for user and sphere handles
//     subhead: TextStyle(
//       fontSize: 15,
//       color: const Color(0xff333333),
//       fontWeight: FontWeight.w700,
//     ),

//     body1: TextStyle(
//       fontSize: 13,
//       color: const Color(0xff555555),
//       fontWeight: FontWeight.w500,
//     ),
//   ),
// );
