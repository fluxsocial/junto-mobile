import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  final UserRepo userRepo;
  final UserDataProvider userDataProvider;

  AuthBloc(this.authRepo, this.userDataProvider, this.userRepo) {
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
    yield AuthState.unauthenticated(loading: true);
    try {
      logger.logInfo('User signed up, now logging in');
      // final login = await authRepo.loginUser(details);
      await authRepo.loginUser(event.username, event.password);
      var userData = await userRepo.sendMetadataPostRegistration(event.details);

      if (event.profilePicture != null) {
        final profile = await userRepo.updateProfilePicture(
            userData.user.address, event.profilePicture);
        logger.logDebug(
            'User profile picture updated, updating the user profile');
        userData = userData.copyWith(user: profile);
      }
      await userDataProvider.updateUser(userData);
      await userDataProvider.initialize();

      yield AuthState.agreementsRequired(userData);
    } on JuntoException catch (e) {
      logger.logError('Error during sign up: ${e.message}');
      await authRepo.logoutUser();

      yield AuthState.unauthenticated();
      yield AuthState.unauthenticated(error: true, errorMessage: e.message);
    } catch (error) {
      logger.logException(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapAcceptAgreementsToState(
      AcceptAgreements event, AuthAgreementsRequired state) async* {
    try {
      yield AuthState.authenticated();
    } catch (error) {
      logger.logException(error);
      yield AuthState.unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginEventState(LoginEvent event) async* {
    yield AuthState.unauthenticated(loading: true);
    try {
      final address = await authRepo.loginUser(event.username, event.password);
      if (address != null) {
        final user = await userRepo.getUser(address);
        await userDataProvider.updateUser(user);
        await userDataProvider.initialize();

        yield AuthState.authenticated();
      }
    } on JuntoException catch (error) {
      logger.logError('Error during login: ${error.message}');
      yield AuthState.unauthenticated();
      yield AuthState.unauthenticated(error: true, errorMessage: error.message);
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
      yield AuthState.authenticated();
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
