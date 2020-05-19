import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  final UserDataProvider userDataProvider;

  AuthBloc(this.authRepo, this.userDataProvider) {
    _getLoggedIn();
  }

  Future<void> _getLoggedIn() async {
    final result = await authRepo.isLoggedIn();
    if (result == true) {
      add(LoggedInEvent());
    } else {
      add(LogoutEvent());
    }
  }

  @override
  AuthState get initialState => AuthState.loading();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUpEvent) {
      yield* _mapSignUpEventState(event);
    }
    if (event is AcceptAgreements) {
      yield* _mapAcceptAgreementsToState(event, state);
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
    yield AuthState.loading();
    try {
      logger.logInfo('User signed up');
      final user =
          await authRepo.registerUser(event.details, event.profilePicture);

      await userDataProvider.initialize();

      yield AuthState.agreementsRequired(user);
    } on JuntoException catch (e) {
      logger.logException(e);
      yield AuthState.unauthenticated();
    } catch (error) {
      logger.logException(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapAcceptAgreementsToState(
      AcceptAgreements event, AuthAgreementsRequired state) async* {
    try {
      yield AuthState.authenticated(state.user);
    } catch (error) {
      logger.logException(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginEventState(LoginEvent event) async* {
    yield AuthState.loading();
    try {
      final user = await authRepo.loginUser(event.details);
      yield AuthState.authenticated(user);
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      yield AuthState.unauthenticated();
    } catch (error) {
      logger.logException(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapLogout(LogoutEvent event) async* {
    yield AuthState.loading();
    try {
      await _clearUserInformation();
      yield AuthState.unauthenticated();
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      yield AuthState.unauthenticated();
    } catch (error) {
      logger.logDebug(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedIn(LoggedInEvent event) async* {
    yield AuthState.loading();
    try {
      final box = await Hive.openBox(HiveBoxes.kAppBox);
      final data = await box.get(HiveKeys.kUserData);
      logger.logDebug(data);
      final user = UserData.fromMap(jsonDecode(data));
      yield AuthState.authenticated(user);
    } on JuntoException catch (error) {
      logger.logDebug(error.message);
      await _clearUserInformation();
      yield AuthState.unauthenticated();
    } catch (error) {
      logger.logException(error);
      await _clearUserInformation();
      yield AuthState.unauthenticated();
    }
  }

  Future<void> _clearUserInformation() async {
    try {
      await authRepo.logoutUser();
    } catch (e, s) {
      logger.logException(e, s, 'Error while clearing the user data');
    }
  }
}
