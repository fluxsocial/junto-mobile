import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationProvider {
  /// Registers a user on the server and creates their holochain profile.
  Future<String> registerUser(UserAuthRegistrationDetails details);

  /// Authenticates a registered user.
  Future<String> loginUser(UserAuthLoginDetails details);

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser();

  /// Returns a map containing the username of the user with the given address.
  /// Result Map contains `{ 'address': 'address-of-profile', entry: { parent: 'parent object (user address)',`
  /// `first_name: 'first_name', 'last_name: 'last_name', bio: 'bio', profile_picture: 'profile_picture',verified: true/false} }`
  Future<Map<String, dynamic>> retrieveUsernameFromAddress(String address);

  /// Retrieves the username associated with the current agent.
  /// Map contains the following `{ 'address': 'address-of-username', 'entry': { 'username': 'username' } }`
  Future<Map<String, dynamic>> retrieveUsernameByAgent();

  /// Retrieves the user's profile associated with the given address.
  /// Resulting map contains `{ 'address': 'address-of-profile', entry: { parent: 'parent object (user address)',`
  /// `first_name: 'first_name', last_name: 'last_name', bio: 'bio', profile_picture: 'profile_picture',verified: true/false} }`
  Future<Map<String, dynamic>> retriveProfileByAgent();
}

/// Concrete implementation of [AuthenticationProvider].
class AuthenticationImp implements AuthenticationProvider {
  /// Creates a new user on the server. Returns the user's ID if the operation is
  /// successful. Method takes [UserAuthRegistrationDetails] as its only
  /// parameter.
  @override
  Future<String> registerUser(UserAuthRegistrationDetails details) async {
    assert(details.isComplete);
    final Map<String, String> payload = <String, String>{
      'email': details.email,
      'password': details.password,
      'first_name': details.firstName,
      'last_name': details.lastName,
    };
    try {
      final http.Response response = await JuntoHttp().post(
        '/register',
        body: payload,
      );
      if (response.statusCode == 200) {
        // Once the user is created, we need to log them in to obtain a auth token.
        await loginUser(UserAuthLoginDetails(
            email: details.email, password: details.password));

        // The response sent back from the server is decoded
        final Map<String, dynamic> results = json.decode(response.body);

        // The user account needs to be created on holochain
        await _createHoloUser(details);

        // The results ID is returned to the user
        return results['user_id'];
      } else {
        throw HttpException('Recieved Status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error in Auth provider $error');
      throw HttpException('Unable to register new user $error');
    }
  }

  /// Logs in a user and stores their auth token locally.
  @override
  Future<String> loginUser(UserAuthLoginDetails details) async {
    assert(details.isComplete);
    final Map<String, String> payload = <String, String>{
      'email': details.email,
      'password': details.password,
    };
    final String jsonData = json.encode(payload);
    try {
      final http.Response response = await http.post(
        Uri.encodeFull('$END_POINT/auth'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonData,
      );

      // Holochain only sends 200 status code...even for errors. Anything
      // other than 200 represents an actual server.
      if (response.statusCode == 200) {
        final Cookie responseCookie =
            Cookie.fromSetCookieValue(response.headers['set-cookie']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth', responseCookie.value);
        return responseCookie.value;
      } else if (response.statusCode == 401) {
        throw const HttpException('Please check your account information.');
      } else {
        print('Response error ${response.toString()}');
        throw HttpException('Recieved Status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error in Auth provider $error');
      throw HttpException('Unable to login existing user $error');
    }
  }

  /// Removes the user's auth token from the device and sets login flag to
  /// false.
  @override
  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('auth');
  }

  /// After the user is created on the server, their account is then created on
  /// Holochain.
  Future<void> _createHoloUser(UserAuthRegistrationDetails profile) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'zome': 'user',
      'function': 'create_user',
      'args': <String, dynamic>{'user_data': profile.toMap()},
    };
    final http.Response holoResponse =
        await JuntoHttp().post('/holochain', body: body);
    if (holoResponse.statusCode == 200) {
      debugPrint(holoResponse.body);
    } else {
      throw HttpException(
          'Holochain sent a response != 200 ${holoResponse.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> retriveProfileByAgent() async {
    final Map<String, dynamic> body = JuntoHttp.holobody(
      'get_user_profile_by_agent_address',
      'user',
      <String, String>{},
    );

    try {
      final http.Response holoResponse =
          await JuntoHttp().post('/holochain', body: body);
      final Map<String, dynamic> juntoResponse =
          JuntoHttp.handleResponse(holoResponse);
      return juntoResponse;
    } on HttpException catch (error) {
      debugPrint('Error occured in user_provider $error');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> retrieveUsernameByAgent() async {
    final Map<String, dynamic> body = JuntoHttp.holobody(
      'get_user_username_by_agent_address',
      'user',
      <String, String>{},
    );

    try {
      final http.Response holoResponse =
          await JuntoHttp().post('/holochain', body: body);
      final Map<String, dynamic> juntoResponse =
          JuntoHttp.handleResponse(holoResponse);
      return juntoResponse;
    } on HttpException catch (error) {
      debugPrint('Error occured in user_provider $error');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> retrieveUsernameFromAddress(
      String address) async {
    final Map<String, dynamic> body = JuntoHttp.holobody(
      'get_user_profile_from_address',
      'user',
      <String, String>{
        'username_address': address,
      },
    );

    try {
      final http.Response holoResponse =
          await JuntoHttp().post('/holochain', body: body);
      final Map<String, dynamic> juntoResponse =
          JuntoHttp.handleResponse(holoResponse);
      return juntoResponse;
    } on HttpException catch (error) {
      debugPrint('Error occured in user_provider $error');
      rethrow;
    }
  }
}
