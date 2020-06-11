import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataProvider(
    this.appRepository,
    this.userRepository,
  ) {
    initialize();
  }

  final AppRepo appRepository;
  final UserRepo userRepository;

  String userAddress;
  UserData userProfile;

  SharedPreferences sharedPreferences;

  Future<void> initialize() async {
    await getUserInformation();
  }

  Future<void> getUserInformation() async {
    try {
      logger.logInfo('Fetching user information');
      final box = await Hive.box(HiveBoxes.kAppBox);
      final userData = await box.get(HiveKeys.kUserData);
      if (userData != null && userData.isNotEmpty) {
        final decodedUserData = jsonDecode(userData);
        userProfile = UserData.fromMap(decodedUserData);
        userAddress = userProfile.user.address;
        notifyListeners();
      } else {
        // final user = userRepository.getUser(userAddress);
      }
    } catch (e) {
      logger.logException(e);
    }
  }

  /// Update cached user information, called by [updateUser]
  Future<void> _setUserInformation(UserData user) async {
    final box = await Hive.box(HiveBoxes.kAppBox);
    await box.delete(HiveKeys.kUserData);
    final userMap = user.toMap();
    final userData = jsonEncode(userMap);
    await box.put(HiveKeys.kUserData, userData);
    await box.delete(HiveKeys.kUserId);
    await box.put(HiveKeys.kUserId, user.user.address);
  }

  /// Updates the user information with [user]
  void updateUser(UserData user) {
    try {
      assert(user.user.address == userAddress);
      logger.logDebug(
          'Current user address is equal to the updated user address: ${user.user.address == userAddress}');
      _setUserInformation(user);
      userProfile = user;
      notifyListeners();
    } catch (e) {
      logger.logException(e);
    }
  }

  Future<void> switchColumnLayout(ExpressionFeedLayout layout) async {
    await appRepository?.setLayout(layout == ExpressionFeedLayout.two);
    notifyListeners();
    await getUserInformation();
  }
}
