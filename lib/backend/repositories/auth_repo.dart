import 'dart:convert';

import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo(this._authService, this._userService);

  final AuthenticationService _authService;
  final UserService _userService;

  String _authKey;
  bool _isLoggedIn;

  String get authKey => _authKey;

  Future<bool> isLoggedIn() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _isLoggedIn = preferences.getBool('isLoggedIn');
    return _isLoggedIn;
  }

  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
    final UserData _data = await _authService.registerUser(details);
    await _authService.loginUser(
      UserAuthLoginDetails(email: details.email, password: details.password),
    );
    _isLoggedIn = true;
    await SharedPreferences.getInstance()
      ..setBool('isLoggedIn', true);
    return _data;
  }

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user. Their cookie is stored locally on device and is used for
  /// all future request.
  Future<UserProfile> loginUser(UserAuthLoginDetails details) async {
    try {
      await _authService.loginUser(details);
      final UserProfile profile =
          await _userService.queryUser(details.email, QueryType.email);
      final LocalStorage _storage = LocalStorage('user-details');
      final bool ready = await _storage.ready;
      if (ready) {
        _storage.setItem(
          'data',
          json.encode(
            profile.toMap(),
          ),
        );
      }
      _isLoggedIn = true;
      await SharedPreferences.getInstance()
        ..setBool('isLoggedIn', true);
      return profile;
    } catch (error) {
      rethrow;
    }
  }

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser() async {
    await _authService.logoutUser();
    _isLoggedIn = false;
  }
}
