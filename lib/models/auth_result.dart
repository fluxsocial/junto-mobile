import 'package:flutter/foundation.dart';

abstract class AuthResult {
  final bool wasSuccessful;

  AuthResult(this.wasSuccessful);
}

enum SignInResultError {
  UserDoesNotExists,
  InvalidPassword,
  PasswordResetRequired,
  UnknownError,
}

class SignInResult extends AuthResult {
  final SignInResultError error;
  SignInResult(
    bool wasSuccessful, [
    this.error,
  ]) : super(wasSuccessful);
  factory SignInResult.signedOut() => SignInResult(
        false,
        SignInResultError.UnknownError,
      );
}

enum SignUpResultError {
  UserAlreadyExists,
  InvalidPassword,
  TooManyRequests,
  UnknownError,
}

class SignUpResult extends AuthResult {
  final bool verificationCodeSent;
  final SignUpResultError error;
  SignUpResult(bool wasSuccessful, this.verificationCodeSent,
      [this.error = SignUpResultError.UnknownError])
      : super(wasSuccessful);
}

class ResetPasswordResult extends AuthResult {
  ResetPasswordResult(bool wasSuccessful) : super(wasSuccessful);
}

class VerifyResult extends AuthResult {
  VerifyResult(bool wasSuccessful) : super(wasSuccessful);
}

class ResendVerifyResult extends AuthResult {
  ResendVerifyResult(bool wasSuccessful) : super(wasSuccessful);
}

class SignOutResult extends AuthResult {
  SignOutResult(bool wasSuccessful) : super(wasSuccessful);
}

class SignInData {
  final String username;
  final String password;

  SignInData({@required this.username, @required this.password});
}

class SignUpData {
  final String username;
  final String email;
  final String password;

  SignUpData(this.username, this.email, this.password);
}

class ResetPasswordData {
  final String email;
  final String password;
  final String confirmationCode;

  ResetPasswordData(this.email, this.password, this.confirmationCode);
}

class VerifyData {
  final String code;
  final String username;

  VerifyData(this.username, this.code);
}

class UserRegistrationDetails {
  UserRegistrationDetails({
    @required this.username,
    @required this.email,
    @required this.name,
    @required this.bio,
    @required this.location,
    @required this.profileImage,
    @required this.backgroundPhoto,
    @required this.gender,
    @required this.website,
  });

  factory UserRegistrationDetails.initial(
    String email,
    String username,
    String name,
    String location,
    String website,
    String gender,
  ) {
    return UserRegistrationDetails(
      username: username,
      name: name,
      email: email,
      location: [location],
      website: [website],
      gender: [gender],
      bio: '',
      backgroundPhoto: '',
      profileImage: [],
    );
  }

  final String username;
  final String email;
  final String name;
  final String bio;
  final List<String> location;
  final List<String> profileImage;
  final String backgroundPhoto;
  final List<String> gender;
  final List<String> website;

  bool get isComplete => username != null && name != null;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'name': name,
      'bio': bio,
      'location': location,
      'profile_image': profileImage,
      'background_photo': backgroundPhoto,
      'gender': gender,
      'website': website,
    };
  }
}
