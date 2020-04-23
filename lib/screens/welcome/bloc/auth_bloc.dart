import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_event.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
