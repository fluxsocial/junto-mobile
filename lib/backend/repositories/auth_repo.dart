import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';

class AuthRepo {
  const AuthRepo(
    this.authService,
    this.userRepo,
    this.expressionService,
    this.themesProvider,
  );

  final AuthenticationService authService;
  final ExpressionService expressionService;
  final UserRepo userRepo;
  final JuntoThemesProvider themesProvider;

  Future<bool> isLoggedIn() async {
    final box = await Hive.box(HiveBoxes.kAppBox);
    final isLoggedIn = await box.get(HiveKeys.kisLoggedIn);
    // Let's check if user is actually logged in
    if (isLoggedIn != null && isLoggedIn) {
      try {
        final id = await box.get(HiveKeys.kUserId);
        await userRepo.getUser(id);
      } on SocketException catch (_) {
        // The user is logged in but offline
        return true;
      } catch (error) {
        logger.logException(error);
        return false;
      }
    }
    return isLoggedIn;
  }

  Future<Map<String, dynamic>> validateUser(
      {String username, String email}) async {
    return authService.validateUser(username: username, email: email);
  }

  Future<String> verifyEmail(String email) async {
    logger.logDebug('Verifying e-mail');
    return authService.verifyEmail(email);
  }

  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(
      UserAuthRegistrationDetails details, File profilePicture) async {
    logger.logDebug('Registering user');
    final UserData _data = await authService.registerUser(details);
    await authService.loginUser(
      UserAuthLoginDetails(
        email: details.email,
        password: details.password,
      ),
    );

    if (profilePicture != null) {
      final key =
          await expressionService.createPhoto(false, '.png', profilePicture);

      //TODO: Don't do it manually
      final _profilePictureKeys = <String, dynamic>{
        'profile_picture': <Map<String, dynamic>>[
          <String, dynamic>{'index': 0, 'key': key},
        ]
      };
      // update user with profile photos
      await userRepo.updateUser(
        _profilePictureKeys,
        _data.user.address,
      );
    }

    final box = await Hive.box(HiveBoxes.kAppBox);
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
      final UserData _user = await authService.loginUser(details);
      final box = await Hive.box(HiveBoxes.kAppBox);
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
        await authService.requestPasswordReset(email);
    return responseStatusCode;
  }

  Future<void> resetPassword(Map<String, dynamic> details) async {
    await authService.resetPassword(details);
  }

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser() async {
    themesProvider.setTheme("rainbow");
    await authService.logoutUser();
  }

  // Delete user account
  Future<void> deleteUserAccount(String userAddress, String password) async {
    return authService.deleteUserAccount(userAddress, password);
  }
}
