import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

/// Repository retrieving and saving various app settings:
///
/// - column layout of expressions
class AppRepo extends ChangeNotifier {
  AppRepo(AppService service) {
    _loadAppConfig();
    _appService = service;
  }

  AppService _appService;
  int get collectivePageIndex => _collectivePageIndex ?? 0;
  int get packsPageIndex => _packsPageIndex ?? 0;

  int _collectivePageIndex;
  int _packsPageIndex;
  Box _appBox;

  bool _twoColumn = true;

  /// Exposes the current layout config.
  bool get twoColumnLayout => _twoColumn;

  /// Loads the previously save configuration. If there is none, it starts with a
  /// default of false.
  Future<void> _loadAppConfig() async {
    _appBox = await Hive.box(HiveBoxes.kAppBox);
    final bool _result = _appBox.get(HiveKeys.kLayoutView);
    if (_result != null) {
      _twoColumn = _result;
    } else {
      await _appBox.put(HiveKeys.kLayoutView, _twoColumn);
    }
    return;
  }

  /// Allows the layout type to be updated and saved.
  Future<void> setLayout(bool value) async {
    _twoColumn = value;
    notifyListeners();
    await _appBox.put(HiveKeys.kLayoutView, value);
    return;
  }

  void setCollectivePageIndex(int index) {
    _collectivePageIndex = index;
    notifyListeners();
  }

  void setPacksPageIndex(int index) {
    _packsPageIndex = index;
    notifyListeners();
  }

  Future<bool> isValidVersion() async {
    final isProd = appConfig.flavor == Flavor.prod;
    final isTst =
        appConfig.flavor == Flavor.tst || appConfig.flavor == Flavor.dev;
    try {
      final serVersion = await _appService.getServerVersion();
      if (isProd) {
        if (Platform.isAndroid) {
          return currentAppVersion.minAndroidBuild >=
              serVersion.minAndroidBuild;
        }
        if (Platform.isIOS) {
          return currentAppVersion.minIosBuild >= serVersion.minIosBuild;
        }
        return false;
      }

      if (isTst) {
        if (Platform.isAndroid) {
          return currentAppVersion.minAndroidBuildTest >=
              serVersion.minAndroidBuildTest;
        }
        if (Platform.isIOS) {
          return currentAppVersion.minIosBuildTest >=
              serVersion.minIosBuildTest;
        }
        return false;
      }
      return false;
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      return false;
    } catch (e) {
      logger.logDebug(e);
      return false;
    }
  }
}
