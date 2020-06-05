import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/models/models.dart';

class AuthRepo {
  const AuthRepo(
    this.authService,
    this.userRepo, {
    this.onLogout,
  });

  final AuthenticationService authService;
  final UserRepo userRepo;
  final void Function() onLogout;

  Future<bool> isLoggedIn() async {
    try {
      final value = await authService.isLoggedIn();
      return value.wasSuccessful;
    } catch (e) {
      logger.logException(e);
      return false;
    }
  }

  Future<bool> usernameAvailable({String username}) async {
    try {
      final value = await userRepo.usernameAvailable(username ?? '');
      return value;
    } catch (e) {
      logger.logException(e);
      return false;
    }
  }

  Future<SignUpResult> signUp(
      String username, String email, String password) async {
    logger.logDebug('Verifying e-mail - signing up in auth service');
    final res = await authService.signUp(SignUpData(username, email, password));
    return res;
  }

  Future<bool> verifySignUp(String username, String code) async {
    logger.logDebug('Checking verification code during sign up');
    final res = await authService.verifySignUp(VerifyData(username, code));
    return res.wasSuccessful;
  }

  Future<bool> resendVerificationCode(
      String username, String email, String password) async {
    logger.logDebug('Resending verification code during sign up');
    final res = await authService
        .resendVerifyCode(SignUpData(username, email, password));
    return res.wasSuccessful;
  }

  //   final box = await Hive.box(HiveBoxes.kAppBox);
  //   await box.put(HiveKeys.kisLoggedIn, true);
  //   await box.put(HiveKeys.kUserId, _data.user.address);
  //   await box.put(
  //     HiveKeys.kUserFollowPerspectiveId,
  //     _data.userPerspective.address,
  //   );
  //   return _data;
  // }

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user.
  Future<void> loginUser(String username, String password) async {
    try {
      final result = await authService
          .loginUser(SignInData(username: username, password: password));
      if (result.wasSuccessful) {
        //TODO: fetch user data
        // final box = await Hive.box(HiveBoxes.kAppBox);
        // await box.put(HiveKeys.kUserId, _user.user.address);
        // await box.put(
        //   HiveKeys.kUserFollowPerspectiveId,
        //   _user.userPerspective.address,
        // );
        // final Map<String, dynamic> _userToMap = _user.toMap();
        // final String _userMapToString = json.encode(_userToMap);
        // await box.put(HiveKeys.kUserData, _userMapToString);
        // return _user;
      } else {
        //TODO: handle unsuccesful login
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error during user login');
      rethrow;
    }
  }

  // Request verification code to reset password
  Future<ResetPasswordResult> requestPasswordReset(String email) async {
    final response = await authService.requestPasswordReset(email);
    return response;
  }

  Future<ResetPasswordResult> resetPassword(ResetPasswordData data) {
    return authService.resetPassword(data);
  }

  Future<void> logoutUser() async {
    if (onLogout != null) {
      await onLogout();
    }
    logger.logInfo('Logging out');
    await authService.logOut();
  }

  // Delete user account
  Future<void> deleteUserAccount(String userAddress, String password) async {
    await authService.deleteUserAccount(userAddress, password);
    await logoutUser();
    return;
  }
}
