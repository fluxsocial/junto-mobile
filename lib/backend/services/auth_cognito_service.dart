import 'package:flutter/services.dart';
import 'package:flutter_aws_amplify_cognito/flutter_aws_amplify_cognito.dart'
    as aws;
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';

class CognitoClient extends AuthenticationService {
  CognitoClient() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.initialize();
      switch (result) {
        case aws.UserStatus.GUEST:
          logger.logInfo('User is not logged in but guest');
          break;
        case aws.UserStatus.SIGNED_IN:
          logger.logInfo('User is logged in');
          break;
        case aws.UserStatus.SIGNED_OUT:
        case aws.UserStatus.SIGNED_OUT_FEDERATED_TOKENS_INVALID:
        case aws.UserStatus.SIGNED_OUT_USER_POOLS_TOKENS_INVALID:
        case aws.UserStatus.UNKNOWN:
        case aws.UserStatus.ERROR:
          logger.logInfo('User is not logged in');
          logger.logInfo(result.toString());
          break;
      }
    } catch (e) {
      logger.logException(e);
    }
  }

  @override
  Future<ResetPasswordResult> requestPasswordReset(String username) async {
    try {
      final result =
          await aws.FlutterAwsAmplifyCognito.forgotPassword(username);
      if (result != null) {
        logger.logDebug('Password reset request result: ${result.state}');
        switch (result.state) {
          case aws.ForgotPasswordState.CONFIRMATION_CODE:
            logger.logInfo(
                "Confirmation code is sent to reset password through ${result.parameters.deliveryMedium}");
            return ResetPasswordResult(true);
          case aws.ForgotPasswordState.DONE:
            return ResetPasswordResult(false);
          case aws.ForgotPasswordState.UNKNOWN:
          case aws.ForgotPasswordState.ERROR:
            return ResetPasswordResult(false);
        }
      }
      return ResetPasswordResult(false);
    } catch (e) {
      logger.logException(e);
      return ResetPasswordResult(false);
    }
  }

  @override
  Future<ResetPasswordResult> resetPassword(ResetPasswordData data) async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.confirmForgotPassword(
          data.username, data.password, data.confirmationCode);
      if (result != null) {
        logger.logDebug('Password reset result: ${result.state}');
        switch (result.state) {
          case aws.ForgotPasswordState.DONE:
            logger.logInfo("Password changed successfully");
            return ResetPasswordResult(true);
          case aws.ForgotPasswordState.CONFIRMATION_CODE:
          case aws.ForgotPasswordState.UNKNOWN:
          case aws.ForgotPasswordState.ERROR:
            return ResetPasswordResult.unknownError();
        }
      }
      return ResetPasswordResult(false);
    } on PlatformException catch (e) {
      if (e.details is String) {
        if (e.details.contains('Attempt limit exceeded')) {
          return ResetPasswordResult(
            false,
            error: ResetPasswordError.TooManyAttempts,
          );
        } else if (e.details.contains('Invalid verification code provided')) {
          return ResetPasswordResult(
            false,
            error: ResetPasswordError.InvalidCode,
          );
        }
      }
      logger.logError('Error while resetting the password: $e');
      return ResetPasswordResult.unknownError();
    } catch (e, s) {
      logger.logException(e, s, 'Unexpected exception when resetting password');
      return ResetPasswordResult.unknownError();
    }
  }

  @override
  Future<ResetPasswordResult> resendVerifyCode(String data) async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.resendSignUp(data);
      logger.logInfo(
          'Result of resending verification code: ${result.confirmationState} ${result.userCodeDeliveryDetails.deliveryMedium}');
      if (result.confirmationState) {
        return ResetPasswordResult(true);
      } else {
        return ResetPasswordResult.unknownError();
      }
    } on PlatformException catch (e) {
      if (e.details is String) {
        if (e.details.contains('Attempt limit exceeded')) {
          return ResetPasswordResult(
            false,
            error: ResetPasswordError.TooManyAttempts,
          );
        } else if (e.details.contains('Invalid verification code provided')) {
          return ResetPasswordResult(
            false,
            error: ResetPasswordError.InvalidCode,
          );
        }
      }
      logger.logError('Error while resetting the password: $e');
      return ResetPasswordResult.unknownError();
    } catch (e, s) {
      logger.logException(e, s,
          'Unexpected error while requesting the verification code again');
      return ResetPasswordResult.unknownError();
    }
  }

  @override
  Future<SignInResult> loginUser(SignInData details) async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.signIn(
        details.username,
        details.password,
      );
      if (result != null) {
        switch (result.signInState) {
          case aws.SignInState.NEW_PASSWORD_REQUIRED:
            return SignInResult(false, SignInResultError.PasswordResetRequired);
          case aws.SignInState.DONE:
            return SignInResult(true);
          case aws.SignInState.SMS_MFA:
          case aws.SignInState.PASSWORD_VERIFIER:
          case aws.SignInState.CUSTOM_CHALLENGE:
          case aws.SignInState.DEVICE_SRP_AUTH:
          case aws.SignInState.DEVICE_PASSWORD_VERIFIER:
          case aws.SignInState.ADMIN_NO_SRP_AUTH:
          case aws.SignInState.UNKNOWN:
          case aws.SignInState.ERROR:
            return SignInResult.signedOut();
        }
      }
      return SignInResult.signedOut();
    } on PlatformException catch (e) {
      logger.logException(e);
      if (e.details != null && e.details is String) {
        if (e.details.contains("There is already a user which is signed in.")) {
          return SignInResult(false, SignInResultError.AlreadyLoggedIn);
        }
        if (e.details.contains("Incorrect username or password")) {
          return SignInResult(false, SignInResultError.InvalidPassword);
        }
      }
      return SignInResult.signedOut();
    } catch (e) {
      return SignInResult.signedOut();
    }
  }

  @override
  Future<SignUpResult> signUp(SignUpData data) async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.signUp(
        data.username,
        data.password,
        {'email': '${data.email}'},
      );
      if (!result.confirmationState) {
        logger.logInfo('Verification code sent to user');
        return SignUpResult(true, false);
      } else {
        logger.logError(
            'Problem with sending verification code to the user: ${result.confirmationState} ${result.userCodeDeliveryDetails?.deliveryMedium}');
        return SignUpResult(false, false);
      }
    } on PlatformException catch (e) {
      logger.logException(e);
      if (e.details != null && e.details is String) {
        final details = e.details as String;
        if (details.contains('UsernameExistsException') ||
            details.contains('User already exists')) {
          return SignUpResult(
              false, false, SignUpResultError.UserAlreadyExists);
        } else if (details.contains('InvalidPasswordException')) {
          return SignUpResult(false, false, SignUpResultError.InvalidPassword);
        } else if (details.contains('TooManyRequestsException')) {
          return SignUpResult(false, false, SignUpResultError.TooManyRequests);
        } else if (details.contains('CodeDeliveryFailureException')) {
          //TODO: handle this?
          return SignUpResult(false, false, SignUpResultError.UnknownError);
        }
      }
      return SignUpResult(false, false);
    } catch (e) {
      logger.logException(e);
      return SignUpResult(false, false);
    }
  }

  @override
  Future<VerifyResult> verifySignUp(VerifyData data) async {
    try {
      final result = await aws.FlutterAwsAmplifyCognito.confirmSignUp(
        data.username,
        data.code,
      );
      if (result.confirmationState) {
        return VerifyResult(true);
      } else {
        return VerifyResult(false);
      }
    } on PlatformException catch (e) {
      logger.logException(e);
      if (e.details.contains('Current status is CONFIRMED')) {
        return VerifyResult(true);
      } else {
        return VerifyResult(false);
      }
    } catch (e) {
      logger.logException(e);
      return VerifyResult(false);
    }
  }

  @override
  Future<SignOutResult> logOut() async {
    try {
      aws.FlutterAwsAmplifyCognito.signOut();
      return SignOutResult(true);
    } catch (e) {
      return SignOutResult(false);
    }
  }

  @override
  Future<SignInResult> isLoggedIn() async {
    try {
      final currentUser = await aws.FlutterAwsAmplifyCognito.currentUserState();

      switch (currentUser) {
        case aws.UserStatus.GUEST:
          return SignInResult.signedOut();
        case aws.UserStatus.SIGNED_IN:
          return SignInResult(true);
          break;
        case aws.UserStatus.SIGNED_OUT:
        case aws.UserStatus.SIGNED_OUT_FEDERATED_TOKENS_INVALID:
        case aws.UserStatus.SIGNED_OUT_USER_POOLS_TOKENS_INVALID:
        case aws.UserStatus.UNKNOWN:
        case aws.UserStatus.ERROR:
          return SignInResult.signedOut();
      }
      return SignInResult.signedOut();
    } catch (e) {
      logger.logException(e);
      return SignInResult.signedOut();
    }
  }

  Stream<SignInResult> isSignedInStream() {
    try {
      return aws.FlutterAwsAmplifyCognito.addUserStateListener.map((event) {
        switch (event) {
          case aws.UserStatus.GUEST:
            return SignInResult.signedOut();
          case aws.UserStatus.SIGNED_IN:
            return SignInResult(true);
            break;
          case aws.UserStatus.SIGNED_OUT:
          case aws.UserStatus.SIGNED_OUT_FEDERATED_TOKENS_INVALID:
          case aws.UserStatus.SIGNED_OUT_USER_POOLS_TOKENS_INVALID:
          case aws.UserStatus.UNKNOWN:
          case aws.UserStatus.ERROR:
            return SignInResult.signedOut();
        }
        return SignInResult.signedOut();
      });
    } catch (e) {
      return Stream.value(SignInResult(false));
    }
  }

  @override
  Future<String> getIdToken() async {
    try {
      final loggedIn = await isLoggedIn();
      if (loggedIn.wasSuccessful) {
        return aws.FlutterAwsAmplifyCognito.getIdToken();
      } else {
        logger.logWarning('Trying to access token when logged out');
        return null;
      }
    } catch (e) {
      logger.logError('Error while accessing id token: ${e}');
      return null;
    }
  }
}
