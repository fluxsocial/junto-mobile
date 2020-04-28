import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataProvider(
    this.appRepository,
  ) {
    initialize();
  }

  final AppRepo appRepository;

  String userAddress;
  UserData userProfile;
  bool twoColumnView = false;

  SharedPreferences sharedPreferences;

  Future<void> initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await getUserInformation();
    return;
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final box = await Hive.openBox("app", encryptionKey: key);
    final userData = prefs.getString('user_data');
    if (userData != null && userData.isNotEmpty) {
      final Map<String, dynamic> decodedUserData = jsonDecode(userData);
      userAddress = box.get("userId");
      userProfile = UserData.fromMap(decodedUserData);
      if (prefs.getBool('twoColumnView') != null) {
        twoColumnView = prefs.getBool('twoColumnView');
      }

      notifyListeners();
    }
    return;
  }

  /// Update cached user information, called by [updateUser]
  Future<void> _setUserInformation(UserData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toMap()));
    final box = await Hive.openBox("app", encryptionKey: key);
    box.delete("userId");
    box.put("userId", user.user.address);
    return;
  }

  /// Updates the user information with [user]
  void updateUser(UserData user) {
    assert(user.user.address == userAddress);
    logger.logDebug(
        'Current user address is equal to the upadted user address: ${user.user.address == userAddress}');
    _setUserInformation(user);
    userProfile = user;
    notifyListeners();
  }

  Future<void> switchColumnLayout(ExpressionFeedLayout layout) async {
    await appRepository?.setLayout(layout == ExpressionFeedLayout.two);
    await getUserInformation();
    notifyListeners();
  }
}
