import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  SignUpEvent(this.details);

  final UserAuthRegistrationDetails details;
}

class LoginEvent extends AuthEvent {
  LoginEvent(this.details);

  final UserAuthLoginDetails details;
}

/// Called when the user is logged into the app.
/// Cases may include: Launching the app from the background, closing and
/// re-opening, etc..
class LoggedInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
