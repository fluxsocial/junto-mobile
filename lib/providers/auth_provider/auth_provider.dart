import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationProvider {
  Future<String> registerUser(UserAuthRegistrationDetails details);
  Future<String> loginUser(UserAuthLoginDetails details);
  Future<void> logouUser();
}

/// Concrete implementation of [AuthenticationProvider].
class AuthenticationImp implements AuthenticationProvider {
  /// Creates a new user on the server. Returns the user's ID if the operation is
  /// sucessful. Method takes [UserAuthRegistrationDetails] as its only parameter.
  @override
  Future<String> registerUser(UserAuthRegistrationDetails details) async {
    assert(details.isComplete);
    final Map<String, String> payload = <String, String>{
      'email': details.email,
      'password': details.password,
      'first_name': details.firstName,
      'last_name': details.lastName,
    };
    final String jsonData = json.encode(payload);
    try {
      final http.Response response = await http.post(
        Uri.encodeFull('$END_POINT/register'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonData,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> results = json.decode(response.body);
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
      if (response.statusCode == 200) {
        final Cookie responseCookie =
            Cookie.fromSetCookieValue(response.headers['set-cookie']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth', responseCookie.value);
        return responseCookie.value;
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
  Future<void> logouUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('auth');
  }
}
