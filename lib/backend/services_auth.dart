part of 'services.dart';

abstract class IdTokenProvider {
  Future<String> getIdToken();
}

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationService extends IdTokenProvider {
  /// Register user on Cognito UserPool
  ///
  /// Results with verification code sent to the user
  ///
  /// Important: user data are not saved on server just yet
  Future<SignUpResult> signUp(SignUpData data);

  /// Allows to resend verification code if not received after [signUp]
  Future<ResetPasswordResult> resendVerifyCode(String data);

  /// Verify user's registration with verification code
  ///
  /// Called after [signUp] or [resendVerifyCode] and user is
  /// registered only after this method finishes with success
  Future<VerifyResult> verifySignUp(VerifyData data);

  /// Request verification code to reset password
  Future<ResetPasswordResult> requestPasswordReset(String email);

  /// Request verification code to reset password
  Future<void> resetPassword(ResetPasswordData details);

  Future<SignInResult> loginUser(SignInData details);

  /// Logs out a user and removes their auth token from the device.
  Future<SignOutResult> logOut();

  /// Gives indication if user is logged in
  Future<SignInResult> isLoggedIn();
}
