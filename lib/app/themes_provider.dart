import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this.currentTheme);

  ThemeData currentTheme;

  ThemeData getTheme() => currentTheme;

  void setTheme(String theme) {
    if (theme == 'light-indigo') {
      currentTheme = JuntoThemes().juntoLightIndigo;
    } else if (theme == 'light-royal') {
      currentTheme = JuntoThemes().juntoLightRoyal;
    } else if (theme == 'night-indigo') {
      currentTheme = JuntoThemes().juntoNight;
    }

    notifyListeners();
  }
}
