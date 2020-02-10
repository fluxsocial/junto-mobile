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
  Future<UserData> loginUser(UserAuthLoginDetails details) async {
    final http.Response response = await client.postWithoutEncoding(
      '/auth',
      body: <String, String>{
        'email': details.email,
        'password': details.password,
      },
    );
    if (response.statusCode == 200) {
      final String authorization = response.headers['authorization'];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', authorization);
      return UserData.fromMap(JuntoHttp.handleResponse(response));
    } else {
      final Map<String, dynamic> errorResponse =
          JuntoHttp.handleResponse(response);
      throw JuntoException(
          'Unable to login: ${errorResponse['error']}', response.statusCode);
    }
  }

  @override
  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('auth');
  }

  @override
  Future<String> verifyEmail(String email) async {
    final Map<String, String> _body = <String, String>{'email': email};
    print(_body);
    final http.Response response =
        await client.postWithoutEncoding('/auth/register', body: _body);
    print(response.body);
    final Map<String, dynamic> parseData = JuntoHttp.handleResponse(response);
    if (parseData['message'] != null) {
      return parseData['message'];
    } else {
      throw JuntoException(parseData['error'], response.statusCode);
    }
  }

  @override
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
    assert(details.name.isNotEmpty);
    assert(details.username.isNotEmpty);
    assert(details.password.isNotEmpty);
    final Map<String, dynamic> _body = <String, dynamic>{
      'email': details.email,
      'password': details.password,
      'confirm_password': details.password,
      'name': details.name,
      'bio': details.bio,
      'username': details.username,
      'website': details.website,
      'gender': details.gender,
      'location': details.location,
      'profile_picture': details.profileImage,
      'verification_code': details.verificationCode
    };

    final http.Response response = await client.postWithoutEncoding(
      '/users',
      body: _body,
    );
    print(response.body);
    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    final UserData _userData = UserData.fromMap(_responseMap);
    return _userData;
  }
}
