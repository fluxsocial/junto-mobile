import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this.currentTheme);
  ThemeData currentTheme;

  getTheme() => currentTheme;

  void setTheme(String theme) {
    if (theme == 'lightSecondary') {
      // currentTheme = JuntoThemes().juntoLightSecondary;
      print('set secondary theme');
    } else if (theme == 'night') {
      currentTheme = JuntoThemes().juntoNight;
      print('set night theme');
    }

    notifyListeners();
  }
}
