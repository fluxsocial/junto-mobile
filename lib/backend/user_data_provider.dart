import 'dart:convert';

import 'package:flutter/material.dart';
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
    final userData = prefs.getString('user_data');
    if (userData != null && userData.isNotEmpty) {
      final Map<String, dynamic> decodedUserData = jsonDecode(userData);

      userAddress = prefs.getString('user_id');
      userProfile = UserData.fromMap(decodedUserData);
      if (prefs.getBool('twoColumnView') != null) {
        twoColumnView = prefs.getBool('twoColumnView');
      }

      notifyListeners();
    }
    return;
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final updatedProfile = userProfile.user.copyWith(
      address: profile.address,
      name: profile.name,
      bio: profile.bio,
      location: profile.location,
      profilePicture: profile.profilePicture,
      backgroundPhoto: profile.backgroundPhoto,
      verified: profile.verified,
      username: profile.username,
      website: profile.website,
      gender: profile.gender,
    );
    userProfile = userProfile.copyWith(user: updatedProfile);
    prefs.setString('user_data', json.encode(userProfile.toMap()));
    prefs.setString('user_id', userProfile.user.address);
    notifyListeners();
    return;
  }

  Future<void> switchColumnLayout(ExpressionFeedLayout layout) async {
    await appRepository?.setLayout(layout == ExpressionFeedLayout.two);
    await getUserInformation();
    notifyListeners();
  }
}
