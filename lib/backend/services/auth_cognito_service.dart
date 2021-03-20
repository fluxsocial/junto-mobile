import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as aws;
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';

import '../../aws_config.dart';

class CognitoClient extends AuthenticationService {
  Amplify amplifyInstance = Amplify();
  aws.AmplifyAuthCognito auth;

  CognitoClient() {
    _initializeCongnito();
  }

  Future<void> _initializeCongnito() async {
    try {
      auth = aws.AmplifyAuthCognito();
      amplifyInstance.addPlugin(authPlugins: [auth]);

      await amplifyInstance.configure(AwsConfig);
      await _initialize();
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Future<void> _initialize() async {
    try {
      final result = await auth.fetchAuthSession();

      if (result.isSignedIn) {
        logger.logInfo('User is logged in');
      } else {
        logger.logInfo('User is not logged in');
      }
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  @override
  Future<ResetPasswordResult> requestPasswordReset(String username) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: username);

      if (result.isPasswordReset) {
        return ResetPasswordResult(true);
      }

      return ResetPasswordResult(false);
    } on PlatformException catch (e) {
      if (e.details is String) {
        if (e.details.contains('Attempt limit exceeded') ||
            e.details.contains('LimitExceededException')) {
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
      logger.logException(e, s);
      return ResetPasswordResult(false);
    }
  }

  @override
  Future<ResetPasswordResult> resetPassword(ResetPasswordData data) async {
    try {
      final result = await Amplify.Auth.confirmPassword(
        username: data.username,
        newPassword: data.password,
        confirmationCode: data.confirmationCode,
      );

      if (result != null) {
        return ResetPasswordResult(true);
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
      final result = await Amplify.Auth.resendSignUpCode(username: data);
      logger.logInfo(
          'Result of resending verification code: ${result.codeDeliveryDetails.attributeName} ${result.codeDeliveryDetails.deliveryMedium}');
      if (result.codeDeliveryDetails.deliveryMedium
          .toLowerCase()
          .contains('email')) {
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
      print('test: 1');
      aws.SignInResult result = await Amplify.Auth.signIn(
          username: details.username, password: details.password);

      print('test: 2 ${result.isSignedIn}');

      if (result != null && result.isSignedIn) {
        print('test: 5 ${result.isSignedIn}');
        return SignInResult(true);
      }

      return SignInResult.signedOut();
    } on PlatformException catch (e, s) {
      print('test');
      logger.logException(e, s);
      if (e.details != null && e.details is String) {
        if (e.details.contains("There is already a user which is signed in.")) {
          return SignInResult(false, SignInResultError.AlreadyLoggedIn);
        }
        if (e.details.contains("Incorrect username or password")) {
          return SignInResult(false, SignInResultError.InvalidPassword);
        }
        if (e.details.contains("User is not confirmed.")) {
          return SignInResult(false, SignInResultError.UserNotConfirmed);
        }
      }
      return SignInResult.signedOut();
    } catch (e) {
      print('test: ${e.toString()}');
      return SignInResult.signedOut();
    }
  }

  @override
  Future<SignUpResult> signUp(SignUpData data) async {
    try {
      Map<String, dynamic> userAttributes = {
        "email": data.email,
      };
      aws.SignUpResult result = await Amplify.Auth.signUp(
        username: data.username,
        password: data.password,
        options: aws.CognitoSignUpOptions(userAttributes: userAttributes),
      );

      logger.logInfo('Verification code sent to user');
      return SignUpResult(true, false);
    } on PlatformException catch (e, s) {
      logger.logException(e, s);

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
          return SignUpResult(false, false, SignUpResultError.UnknownError);
        } else {
          return SignUpResult(false, false, SignUpResultError.UnknownError);
        }
      }
      return SignUpResult(false, false);
    } catch (e, s) {
      logger.logException(e, s);
      return SignUpResult(false, false);
    }
  }

  @override
  Future<VerifyResult> verifySignUp(VerifyData data) async {
    try {
      aws.SignUpResult result = await Amplify.Auth.confirmSignUp(
        username: data.username,
        confirmationCode: data.code,
      );

      if (result.isSignUpComplete) {
        return VerifyResult(true);
      } else {
        return VerifyResult(false);
      }
    } on PlatformException catch (e, s) {
      logger.logException(e, s);
      if (e.details.contains('Current status is CONFIRMED')) {
        return VerifyResult(true);
      } else {
        return VerifyResult(false);
      }
    } catch (e, s) {
      logger.logException(e, s);
      return VerifyResult(false);
    }
  }

  @override
  Future<SignOutResult> logOut() async {
    try {
      await await Amplify.Auth.signOut();
      return SignOutResult(true);
    } catch (e) {
      return SignOutResult(false);
    }
  }

  @override
  Future<SignInResult> isLoggedIn() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      print('test: 3 ${currentUser}');

      if (currentUser != null) {
        return SignInResult(true);
      }

      return SignInResult.signedOut();
    } catch (e, s) {
      print('test: 4 ${e.cause}');
      logger.logException(e, s);
      return SignInResult.signedOut();
    }
  }

  Stream<SignInResult> isSignedInStream() {
    try {
      return auth.events.listenToAuth((msg) {
        switch (msg["eventName"]) {
          case "SIGNED_IN":
            return SignInResult(true);
          case "SIGNED_OUT":
            return SignInResult.signedOut();
          case "SESSION_EXPIRED":
            return SignInResult.signedOut();
        }
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
        aws.CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
          options: aws.CognitoSessionOptions(getAWSCredentials: true),
        );

        return session.userPoolTokens.idToken;
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
