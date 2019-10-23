import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AuthenticationServiceCentralized implements AuthenticationService {
  const AuthenticationServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  Future<void> loginUser(UserAuthLoginDetails details) async {
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
    return _userData;
  }
}
