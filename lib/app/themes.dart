import 'package:flutter/material.dart';

class JuntoThemes {
  // Rainbow Theme
  ThemeData rainbow = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Aqueous Theme
  ThemeData aqueous = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF2E4F78),
    colorScheme: const ColorScheme(
      // Dark blue
      primary: Color(0xFF1A2F54),
      primaryVariant: Color(0xFF5D8EBD),

      // Light Blue
      secondary: Color(0xff2B5583),
      secondaryVariant: Color(0xff2B5583),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Royal Theme
  ThemeData royal = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF7C5C97),
    colorScheme: const ColorScheme(
        // Junto purple
        primary: Color(0xff6F51A8),
        primaryVariant: Color(0xFF7C5C97),
        // Junto gold
        secondary: Color(0xFFE8B974),
        secondaryVariant: Color(0xFFE8B974),
        surface: Color(0xff555555),
        background: Colors.white,
        error: Color(0xff333333),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xff333333),
        onError: Color(0xff333333),
        onSurface: Color(0xfff9f9f9),
        brightness: Brightness.light),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Fire Theme
  ThemeData fire = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Forest Theme
  ThemeData forest = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Sand Light
  ThemeData sand = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Dark Light Theme
  ThemeData dark = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xff555555),
    primaryColorDark: const Color(0xff333333),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xffeeeeee),
    backgroundColor: Colors.white,
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff555555),
      background: Colors.white,
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xfff9f9f9),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Color(0xff333333),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xff333333),
        size: 22,
      ),
    ),
    bottomAppBarColor: Colors.white,
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Color(0xff333333),
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Color(0xff333333),
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xff555555),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xff333333),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xff555555),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Rainbow Night Theme
  ThemeData rainbowNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Aqueous Night Theme
  ThemeData aqueousNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF2E4F78),
    colorScheme: const ColorScheme(
      // Dark blue
      primary: Color(0xFF1A2F54),
      primaryVariant: Color(0xFF5D8EBD),

      // Light Blue
      secondary: Color(0xff2B5583),
      secondaryVariant: Color(0xff2B5583),

      surface: Color(0xff444444),

      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Royal Theme
  ThemeData royalNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF7C5C97),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff6F51A8),
      primaryVariant: Color(0xFF7C5C97),
      // Junto gold
      secondary: Color(0xFFE8B974),
      secondaryVariant: Color(0xFFE8B974),
      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

// Night Theme
  ThemeData night = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Avenir',
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF2B2B2B),
    colorScheme: const ColorScheme(
      primary: Color(0xff222222),
      primaryVariant: Color(0xff2B2B2B),
      secondary: Color(0xFF3C3C3C),
      secondaryVariant: Color(0xff3C3C3C),
      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Fire Night Theme
  ThemeData fireNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Forest Night Theme
  ThemeData forestNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Rainbow Night Theme
  ThemeData sandNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );

  // Dark Night Theme
  ThemeData darkNight = ThemeData(
    fontFamily: 'Avenir',
    brightness: Brightness.dark,
    primaryColor: const Color(0xfff0f0f0),
    primaryColorDark: const Color(0xffffffff),
    primaryColorLight: const Color(0xff999999),
    dividerColor: const Color(0xff555555),
    backgroundColor: const Color(0xff333333),
    accentColor: const Color(0xFF4687A2),
    colorScheme: const ColorScheme(
      // Junto purple
      primary: Color(0xff8E8098),
      primaryVariant: Color(0xffB3808F),
      // Junto blue
      secondary: Color(0xFF307FAA),
      secondaryVariant: Color(0xFF4687A2),

      surface: Color(0xff444444),
      background: Color(0xff333333),
      error: Color(0xff333333),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xff333333),
      onError: Color(0xff333333),
      onSurface: Color(0xff393939),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xff333333),
    appBarTheme: const AppBarTheme(
      color: Color(0xff333333),
      elevation: 0,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.02,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 22,
      ),
    ),
    bottomAppBarColor: const Color(0xff333333),
    textTheme: const TextTheme(
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      // used for user and sphere handles
      subtitle1: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 13,
        color: Color(0xfffbfbfb),
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        color: Color(0xfff0f0f0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Color(0xfff0f0f0),
      ),
      overline: TextStyle(
        fontSize: 12,
        color: Color(0xffeeeeee),
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      ),
    ),
  );
}
