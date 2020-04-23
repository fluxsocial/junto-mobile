import 'dart:async';
import 'dart:convert' show json;

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_event.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) {
    _getLoggedIn();
  }

  Future<void> _getLoggedIn() async {
    final result = await authRepo.isLoggedIn();
    if (result) {
      add(LoggedInEvent());
      return;
    }
    if (!result) {
      add(LogoutEvent());
      return;
    }
  }

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUpEvent) {
      yield* _mapSignUpEventState(event);
    }
    if (event is LoginEvent) {
      yield* _mapLoginEventState(event);
    }
    if (event is LogoutEvent) {
      yield* _mapLogout(event);
    }
    if (event is LoggedInEvent) {
      yield* _mapLoggedIn(event);
    }
  }

  Stream<AuthState> _mapSignUpEventState(SignUpEvent event) async* {
    yield LoadingState();
    try {
      final user = await authRepo.registerUser(event.details);
      yield AuthenticatedState(user);
    } on JuntoException catch (error) {
      yield UnAuthenticatedState();
    } catch (error) {
      yield UnAuthenticatedState();
    }
  }

  Stream<AuthState> _mapLoginEventState(LoginEvent event) async* {
    yield LoadingState();
    try {
      final user = await authRepo.loginUser(event.details);
      yield AuthenticatedState(user);
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      yield UnAuthenticatedState();
    } catch (error) {
      logger.logDebug(error);
      yield UnAuthenticatedState();
    }
  }

  Stream<AuthState> _mapLogout(LogoutEvent event) async* {
    yield LoadingState();
    try {
      final _prefs = await SharedPreferences.getInstance();
      await authRepo.logoutUser();
      await _prefs.clear();
      yield UnAuthenticatedState();
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      yield UnAuthenticatedState();
    } catch (error) {
      logger.logDebug(error);
      yield UnAuthenticatedState();
    }
  }

  Stream<AuthState> _mapLoggedIn(LoggedInEvent event) async* {
    yield LoadingState();
    try {
      final _prefs = await SharedPreferences.getInstance();
      final data = await _prefs.getString('user_data');
      logger.logDebug(data);
      yield AuthenticatedState(UserData.fromMap(json.decode(data)));
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      yield UnAuthenticatedState();
    } catch (error) {
      logger.logDebug(error.message);
      yield UnAuthenticatedState();
    }
  }
}
