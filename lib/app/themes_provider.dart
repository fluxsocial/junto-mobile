import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:vibration/vibration.dart';

abstract class ThemesProvider {
  ThemeData get currentTheme;
}

class JuntoThemesProvider extends ThemesProvider with ChangeNotifier {
  JuntoThemesProvider() {
    initialize();
  }

  @override
  ThemeData get currentTheme => _themes[themeName];

  final String _nightSuffix = '-night';

  String _themeName = 'rainbow';
  String get themeName => _nightMode ? '$_themeName$_nightSuffix' : _themeName;

  bool _nightMode = false;
  bool get nightMode => _nightMode;

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
      final theme = await box.get(HiveKeys.kTheme) as String;
      final nightMode = await box.get(HiveKeys.kNightMode) as bool;
      _nightMode = nightMode ?? false;

      if (theme != null && theme.isNotEmpty) {
        // don't store "-night" suffix in cache
        if (theme.contains(_nightSuffix)) {
          final themeTrimmed =
              theme.substring(0, theme.length - _nightSuffix.length);
          await box.put(HiveKeys.kTheme, themeTrimmed);
          _themeName = themeTrimmed;
        } else {
          _themeName = theme;
        }
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
    logger.logDebug('Setting theme to $themeName with night mode $_nightMode');
    _themeName = themeName;
    notifyListeners();
    _persistTheme(themeName);
    _setSystemOverlay();
    _vibrate();
    return currentTheme;
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        duration: 200,
      );
    }
  }

  void setNightMode(bool enabled) async {
    _nightMode = enabled;
    notifyListeners();
    final box = await Hive.box(HiveBoxes.kAppBox);
    await box.put(HiveKeys.kNightMode, enabled);
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
