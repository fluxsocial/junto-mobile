import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

abstract class ThemesProvider {
  ThemeData get currentTheme;
}

class JuntoThemesProvider extends ThemesProvider with ChangeNotifier {
  JuntoThemesProvider() {
    initialize();
  }

  @override
  ThemeData get currentTheme => _themes[_themeName];

  String _themeName = 'rainbow';
  String get themeName => _themeName;

  static final Map<String, ThemeData> _themes = <String, ThemeData>{
    'rainbow': JuntoThemes().rainbow,
    'aqueous': JuntoThemes().aqueous,
    'royal': JuntoThemes().royal,
    'rainbow-night': JuntoThemes().rainbowNight,
    'aqueous-night': JuntoThemes().aqueousNight,
    'royal-night': JuntoThemes().royalNight,
  };

  Future<void> initialize() async {
    try {
      final box = await Hive.box(HiveBoxes.kAppBox);
      final String theme = await box.get(HiveKeys.kTheme) as String;

      if (theme != null && theme.isNotEmpty) {
        _themeName = theme;
      }
      logger.logDebug('Theme initialized to $themeName');
      notifyListeners();
    } on HiveError catch (e) {
      logger.logException(e);
      await Hive.deleteBoxFromDisk(HiveBoxes.kAppBox);
    } catch (e) {
      logger.logException(e);
    }
  }

  ThemeData setTheme(String themeName) {
    logger.logDebug('Setting theme to $themeName');
    _themeName = themeName;
    notifyListeners();
    _persistTheme(themeName);
    _setSystemOverlay();
    return currentTheme;
  }

  void _setSystemOverlay() {
    if (currentTheme != null) {
      currentTheme.brightness == Brightness.dark
          ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
          : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }

  Future<void> _persistTheme(String value) async {
    final box = await Hive.box(HiveBoxes.kAppBox);
    box.put(HiveKeys.kTheme, value);
    return;
  }
}

class MockedThemesProvider extends ThemesProvider {
  @override
  ThemeData get currentTheme => ThemeData.light();
}
