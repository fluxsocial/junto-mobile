import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class WorkingEvent extends AuthEvent {}

class ErrorEvent extends AuthEvent {
  ErrorEvent(this.error);

  final String error;
}
