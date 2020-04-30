import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
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
    await getUserInformation();
    return;
  }

  Future<void> getUserInformation() async {
    final box = await Hive.openBox(HiveBoxes.kAppBox, encryptionKey: key);
    final userData = box.get(HiveKeys.kUserData);
    if (userData != null && userData.isNotEmpty) {
      final Map<String, dynamic> decodedUserData = jsonDecode(userData);
      userProfile = UserData.fromMap(decodedUserData);
      userAddress = userProfile.user.address;
      if (box.get(HiveKeys.kLayoutView) != null) {
        twoColumnView = box.get(HiveKeys.kLayoutView);
      }

      notifyListeners();
    }
    return;
  }

  /// Update cached user information, called by [updateUser]
  Future<void> _setUserInformation(UserData user) async {
    final box = await Hive.openBox(HiveBoxes.kAppBox, encryptionKey: key);
    box.delete(HiveKeys.kUserData);
    box.put(HiveKeys.kUserData, jsonEncode(user.toMap()));
    box.delete(HiveKeys.kUserId);
    box.put(HiveKeys.kUserId, user.user.address);
  }

  /// Updates the user information with [user]
  void updateUser(UserData user) {
    assert(user.user.address == userAddress);
    logger.logDebug(
        'Current user address is equal to the updated user address: ${user.user.address == userAddress}');
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
