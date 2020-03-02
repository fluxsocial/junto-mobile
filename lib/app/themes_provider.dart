import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this.currentTheme);

  static final Map<String, ThemeData> _themes = <String, ThemeData>{
    'rainbow': JuntoThemes().rainbow,
    'aqueous': JuntoThemes().aqueous,
    'royal': JuntoThemes().royal,
    'rainbow-night': JuntoThemes().rainbowNight,
    'aqueous-night': JuntoThemes().aqueousNight,
    'royal-night': JuntoThemes().royalNight,
  };

  static Future<ThemeData> loadDefault() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _currentTheme = prefs.getString('current-theme');
    if (_currentTheme != null && _currentTheme.isNotEmpty) {
      return _themes[_currentTheme];
    }
    return _themes['rainbow'];
  }

  ThemeData currentTheme;

  ThemeData getTheme() => currentTheme;

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
