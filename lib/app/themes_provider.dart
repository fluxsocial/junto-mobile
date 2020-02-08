import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/app/themes.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this.currentTheme);

  ThemeData currentTheme;

  ThemeData getTheme() => currentTheme;

  void setTheme(String theme) {
    if (theme == 'light-indigo') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      currentTheme = JuntoThemes().juntoLightIndigo;
    } else if (theme == 'light-royal') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      currentTheme = JuntoThemes().juntoLightRoyal;
    } else if (theme == 'night-indigo') {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      currentTheme = JuntoThemes().juntoNight;
    }

    notifyListeners();
  }
}
