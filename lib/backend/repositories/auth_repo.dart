import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';

class AuthRepo {
  AuthRepo(this._authService, this._userRepo);

  final AuthenticationService _authService;
  final UserRepo _userRepo;
  LazyBox box;
  String _authKey;
  bool _isLoggedIn;

  String get authKey => _authKey;

  Future<bool> isLoggedIn() async {
    box = await Hive.openLazyBox(HiveBoxes.kAppBox, encryptionKey: key);
    _isLoggedIn = await box.get(HiveKeys.kisLoggedIn);
    // Let's check if user is actually logged in
    if (_isLoggedIn != null && _isLoggedIn) {
      try {
        final id = await box.get(HiveKeys.kUserId);
        await _userRepo.getUser(id);
      } on SocketException catch (_) {
        // The user is logged in but offline
        return true;
      } catch (error) {
        logger.logException(error);
        return false;
      }
    }
    return _isLoggedIn;
  }

  Future<Map<String, dynamic>> validateUser(
      {String username, String email}) async {
    return _authService.validateUser(username: username, email: email);
  }

  Future<String> verifyEmail(String email) async {
    logger.logDebug('Verifying e-mail');
    return _authService.verifyEmail(email);
  }

  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
    logger.logDebug('Registering user');
    final UserData _data = await _authService.registerUser(details);
    await _authService.loginUser(
      UserAuthLoginDetails(
        email: details.email,
        password: details.password,
      ),
    );
    await box.put(HiveKeys.kisLoggedIn, true);
    await box.put(HiveKeys.kUserId, _data.user.address);
    await box.put(
      HiveKeys.kUserFollowPerspectiveId,
      _data.userPerspective.address,
    );
    return _data;
  }

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user. Their cookie is stored locally on device and is used for
  /// all future request.
  Future<UserData> loginUser(UserAuthLoginDetails details) async {
    try {
      final UserData _user = await _authService.loginUser(details);
      final box = await Hive.openLazyBox(HiveBoxes.kAppBox, encryptionKey: key);
      await box.put(HiveKeys.kisLoggedIn, true);
      await box.put(HiveKeys.kUserId, _user.user.address);
      await box.put(
        HiveKeys.kUserFollowPerspectiveId,
        _user.userPerspective.address,
      );
      final Map<String, dynamic> _userToMap = _user.toMap();
      final String _userMapToString = json.encode(_userToMap);
      await box.put(HiveKeys.kUserData, _userMapToString);
      return _user;
    } catch (e, s) {
      logger.logException(e, s, 'Error during user login');
      rethrow;
    }
  }

  // Request verification code to reset password
  Future<int> requestPasswordReset(String email) async {
    final int responseStatusCode =
        await _authService.requestPasswordReset(email);
    return responseStatusCode;
  }

  Future<void> resetPassword(Map<String, dynamic> details) async {
    await _authService.resetPassword(details);
  }

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser() async {
    await _authService.logoutUser();
    box = null;
    _isLoggedIn = false;
  }
}
