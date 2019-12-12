import 'dart:convert';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo(this._authService);

  final AuthenticationService _authService;

  String _authKey;
  bool _isLoggedIn;

  String get authKey => _authKey;

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn');
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
  Future<UserData> loginUser(UserAuthLoginDetails details) async {
    try {
      final UserData _user = await _authService.loginUser(details);
      final Map _userToMap = _user.toMap();
      final String _userMapToString = json.encode(_userToMap);
      print(_userMapToString);
      final LocalStorage _storage = LocalStorage('user-details');
      final bool ready = await _storage.ready;
      if (ready) {
        _storage.setItem('data', _user.toMap());
      }
      _isLoggedIn = true;
      await SharedPreferences.getInstance()
        ..setBool('isLoggedIn', true)
        ..setString('user_data', _userMapToString);
      return _user;
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
