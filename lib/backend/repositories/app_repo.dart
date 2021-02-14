import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';

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

  int get groupsPageIndex => _groupPageIndex ?? 0;

  int _collectivePageIndex;
  int _packsPageIndex;
  int _groupPageIndex;
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

  Future<bool> isFirstLaunch() async {
    final _appBox = await Hive.box(HiveBoxes.kAppBox);
    final bool _result = _appBox.get(HiveKeys.kFirstLaunch);
    if (_result != null) {
      return _result;
    } else {
      return true;
    }
  }

  Future<void> setFirstLaunch() async {
    try {
      _appBox = await Hive.box(HiveBoxes.kAppBox);
      await _appBox.put(HiveKeys.kFirstLaunch, true);
    } catch (e) {
      logger.logDebug("Unable to set first launch");
    }
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

  void setGroupsPageIndex(int index) {
    _groupPageIndex = index;
    notifyListeners();
  }

  Future<bool> isValidVersion() async {
    final isProd = appConfig.flavor == Flavor.prod;
    try {
      final serVersion = await _appService.getServerVersion();
      if (isProd) {
        if (Platform.isAndroid) {
          return currentAppVersion.minAndroidBuild >=
              serVersion.minAndroidBuild;
        } else {
          return currentAppVersion.minIosBuild >= serVersion.minIosBuild;
        }
      } else {
        return false;
      }
    } on DioError catch (error) {
      print(error.response.data);
      return false;
    } catch (e, s) {
      logger.logException(e, s);
      return false;
    }
  }
}
