import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';

class AuthRepo {
  const AuthRepo(
    this.authService, {
    this.onLogout,
  });

  final AuthenticationService authService;
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

  Future<ResetPasswordResult> resendVerificationCode(String username) {
    logger.logDebug('Resending verification code during sign up');
    return authService.resendVerifyCode(username);
  }

  /// Authenticates a registered user. Returns the [address] for the
  /// given user.
  Future<String> loginUser(String username, String password) async {
    try {
      logger.logInfo('Logging user in');
      final result = await authService
          .loginUser(SignInData(username: username, password: password));
      if (result.wasSuccessful) {
        return await getAddress();
      } else {
        if (result.error == SignInResultError.AlreadyLoggedIn) {
          logger.logInfo('User already logged in, loggin out and relogging');
          await logoutUser();
          return await loginUser(username, password);
        }
        return null;
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error during user login');
      rethrow;
    }
  }

  Future<String> getAddress() async {
    final token = await authService.getIdToken();
    if (token != null) {
      final jwt = JWT.parse(token);
      return jwt.subject;
    } else {
      throw Exception("Access token is null");
    }
  }

  // Request verification code to reset password
  Future<ResetPasswordResult> requestPasswordReset(String username) {
    return authService.requestPasswordReset(username);
  }

  Future<ResetPasswordResult> resetPassword(ResetPasswordData data) {
    assert(data.username.isNotEmpty);
    assert(data.password.isNotEmpty);
    assert(data.confirmationCode.isNotEmpty);
    return authService.resetPassword(data);
  }

  Future<void> logoutUser() async {
    if (onLogout != null) {
      await onLogout();
    }
    logger.logInfo('Logging out');
    await authService.logOut();
  }
}
