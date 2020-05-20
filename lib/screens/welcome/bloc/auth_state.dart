import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  factory AuthState.loading() = AuthLoading;
  factory AuthState.agreementsRequired(UserData user) = AuthAgreementsRequired;
  factory AuthState.authenticated(UserData user) = AuthAuthenticated;
  factory AuthState.unauthenticated(
      {bool loading, bool error, String errorMessage}) = AuthUnauthenticated;
}
