import 'package:junto_beta_mobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class AuthenticatedState extends AuthState {
  AuthenticatedState(this.user);

  final UserData user;
}

class UnAuthenticatedState extends AuthState {}

/// Used to indicate some background task is in progress.
class WorkingState extends AuthState {}

/// Called when an error occurs.
class ErrorState extends AuthState {
  ErrorState(this.error);

  final String error;
}
