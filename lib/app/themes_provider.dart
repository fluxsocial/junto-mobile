import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this.currentTheme);

  static final Map<String, ThemeData> _themes = <String, ThemeData>{
    'light-indigo': JuntoThemes().juntoLightIndigo,
    'night-indigo': JuntoThemes().juntoNight,
    'light-royal': JuntoThemes().juntoLightRoyal
  };

  static Future<ThemeData> loadDefault() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentTheme = prefs.getString('current-theme');
    if (currentTheme != null && currentTheme.isNotEmpty) {
      return _themes[currentTheme];
    }
    return _themes['light-indigo'];
  }

  ThemeData currentTheme;

  ThemeData getTheme() {
    return currentTheme;
  }

  ThemeData setTheme(String theme) {
    _persistTheme(theme);
    currentTheme = _themes[theme];
    notifyListeners();
    return currentTheme;
  }

  Future<void> _persistTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current-theme', value);
  }
}
