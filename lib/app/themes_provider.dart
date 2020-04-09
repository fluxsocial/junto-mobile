import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoThemesProvider with ChangeNotifier {
  JuntoThemesProvider(this._currentTheme) {
    _themeName = _themes.keys
        .firstWhere((k) => _themes[k] == _currentTheme, orElse: () => null);
    print(_themeName);
  }

  static final Map<String, ThemeData> _themes = <String, ThemeData>{
    'rainbow': JuntoThemes().rainbow,
    'aqueous': JuntoThemes().aqueous,
    'royal': JuntoThemes().royal,
    'rainbow-night': JuntoThemes().rainbowNight,
    'aqueous-night': JuntoThemes().aqueousNight,
    'royal-night': JuntoThemes().royalNight,
  };

  static Future<ThemeData> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _currentTheme = prefs.getString('current-theme');

    if (_currentTheme != null && _currentTheme.isNotEmpty) {
      return _themes[_currentTheme];
    }
    return _themes['rainbow'];
  }

  ThemeData get currentTheme => _currentTheme;
  ThemeData _currentTheme;
  ThemeData setTheme(String themeName) {
    logger.logDebug('Setting theme to $themeName');
    _themeName = themeName;
    _currentTheme = _themes[themeName];
    notifyListeners();
    _persistTheme(themeName);
    return currentTheme;
  }

  String _themeName;
  String get themeName => _themeName;

  Future<void> _persistTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('current-theme', value);
  }
}
