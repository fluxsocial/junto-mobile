import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';

@immutable
class AuthenticationServiceCentralized implements AuthenticationService {
  const AuthenticationServiceCentralized(this.client, this.dbService);

  final JuntoHttp client;
  final LocalCache dbService;

  @override
  Future<UserData> loginUser(UserAuthLoginDetails details) async {
    logger.logInfo('Logging in user');
    final http.Response response = await client.postWithoutEncoding(
      '/auth',
      body: <String, String>{
        'email': details.email,
        'password': details.password,
      },
    );
    if (response.statusCode == 200) {
      logger.logInfo('User logged in');
      final String authorization = response.headers['authorization'];
      final box = await Hive.box(HiveBoxes.kAppBox);
      await box.put(HiveKeys.kAuth, authorization);
      final userData = JuntoHttp.handleResponse(response);
      final user = UserData.fromMap(userData);
      final userMap = jsonEncode(userData);
      logger.logInfo('Storing user data');
      await box.put(HiveKeys.kUserData, userMap);
      return user;
    } else {
      final Map<String, dynamic> errorResponse =
          JuntoHttp.handleResponse(response);
      throw JuntoException(
          'Unable to login: ${errorResponse['error']}', response.statusCode);
    }
  }

  @override
  Future<void> logoutUser() async {
    await dbService.wipe();

    logger.logInfo('User logged out, cache cleaned');
  }

  @override
  Future<Map<String, dynamic>> validateUser(
      {String username, String email}) async {
    final Map<String, String> _body = <String, String>{};
    if (username != null && username != '') {
      _body['username'] = username;
    }
    if (email != null && email != '') {
      _body['email'] = email;
    }
    print(_body);
    final http.Response response =
        await client.postWithoutEncoding('/users/validate', body: _body);
    print(response.statusCode);
    print(response.body);
    print(response.statusCode);
    final parseData = JuntoHttp.handleResponse(response);
    return parseData;
  }

  @override
  Future<String> verifyEmail(String email) async {
    final Map<String, String> _body = <String, String>{'email': email};
    logger.logDebug(_body.toString());
    final http.Response response =
        await client.postWithoutEncoding('/auth/register', body: _body);
    logger.logDebug('${response.statusCode} ${response.body}');
    if (response.statusCode == 310) {
      print('yeo');
      return 'follow the white rabbit';
    }
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
    logger.logDebug(response.body);
    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    final UserData _userData = UserData.fromMap(_responseMap);
    return _userData;
  }

  @override
  Future<int> requestPasswordReset(String email) async {
    final Map<String, dynamic> _body = <String, dynamic>{
      'email': email,
    };
    final http.Response response = await client.postWithoutEncoding(
      '/auth/forgot',
      body: _body,
    );
    logger.logDebug("Request code ${response.body}");

    if (response.statusCode == 310) {
      return 310;
    } else {
      final Map<String, dynamic> _responseMap =
          JuntoHttp.handleResponse(response);
      print(_responseMap);
    }
    return response.statusCode;
  }

  @override
  Future<void> resetPassword(Map<String, dynamic> details) async {
    final Map<String, dynamic> _body = <String, dynamic>{
      'email': details['email'],
      'verification_code': details['verification_code'],
      'password': details['password'],
      'confirm_password': details['confirm_password']
    };
    final http.Response response = await client.postWithoutEncoding(
      '/auth/reset',
      body: _body,
    );
    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
  }

  Future<void> deleteUserAccount(String userAddress, String password) async {
    final Map<String, dynamic> _body = <String, dynamic>{
      'password': password,
    };
    print('first step');
    final http.Response response = await client.postWithoutEncoding(
      '/users/$userAddress',
      body: _body,
    );

    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
  }
}
