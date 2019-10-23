import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AuthenticationServiceCentralized implements AuthenticationService {
  const AuthenticationServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  Future<UserProfile> loginUser(UserAuthLoginDetails details) async {
    final http.Response response = await client.post(
      '/auth',
      body: <String, String>{
        'email': details.email,
        'password': details.password,
      },
    );
    if (response.statusCode == 200) {
      // Decodes the server cookie.
      final Cookie responseCookie =
          Cookie.fromSetCookieValue(response.headers['set-cookie']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', responseCookie.value);

      // FIXME: response should contain userAddress so that we can fetch wit that
      // Once we authenticate the user, we can get their [UserProfile].
      final UserProfile _userData = await _retrieveUserByEmail(details.email);
      await _setLocalUserProfile(_userData);
      return _userData;
    } else {
      final Map<String, dynamic> errorResponse = JuntoHttp.handleResponse(response);
      throw JuntoException('Unable to login: ${errorResponse['error']}');
    }
  }

  @override
  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('auth');
  }

  @override
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
    final Map<String, dynamic> _body = <String, dynamic>{
      'email': details.email,
      'password': details.password,
      'confirm_password': details.password,
      'first_name': details.firstName,
      'last_name': details.lastName,
      'bio': details.bio,
      'username': details.username,
      'profile_picture': details.profileImage ?? ''
    };

    final http.Response response = await client.post(
      '/users',
      body: _body,
    );
    final Map<String, dynamic> _responseMap = JuntoHttp.handleResponse(response);
    final UserData _userData = UserData.fromMap(_responseMap);
    // We need to manually login a user after their account has been create
    // to obtain an auth cookie.
    await loginUser(
      UserAuthLoginDetails(
        email: details.email,
        password: details.password,
      ),
    );
    await _setLocalUserProfile(_userData.user);
    return _userData;
  }

  /// Private function which returns the [UserProfile] for the given email
  /// address.
  Future<UserProfile> _retrieveUserByEmail(String email) async {
    // The endpoint requires us to pass our args as `query params`.
    final Map<String, String> _queryParams = <String, String>{
      'email': email,
    };
    // Authentication is required for this endpoint
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String authKey = _prefs.getString('auth');

    // Build `URI` with [_queryParams]
    final Uri _uri = Uri.http('198.199.67.10', '/users', _queryParams);

    // Get data from the server
    final http.Response _serverResponse = await http.get(
      _uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'cookie': 'auth=$authKey',
      },
    );
    // The server returns a list of results back to us. `json.decode` returns
    // an `Iterable` for decoded json data. Since we know our data is only
    // going to contain one result, we can use the `.first` property to
    // obtain the map data for the given user profile.
    final Iterable<dynamic> _listData = json.decode(_serverResponse.body);
    // We the list can be empty if the user does not have a profile.
    if (_listData.isNotEmpty) {
      return UserProfile.fromMap(_listData.first);
    }
    // Throw an exception if the user does not have a profile.
    throw const JuntoException('Unable to retrive user profile');
  }

  Future<void> _setLocalUserProfile(UserProfile profile) async {
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
  }
}
