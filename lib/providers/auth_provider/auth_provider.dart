import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationProvider {
  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(UserAuthRegistrationDetails details);

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user. Their cookie is stored locally on device and is used for
  /// all future request.
  Future<UserProfile> loginUser(UserAuthLoginDetails details);

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
  Future<Map<String, dynamic>> retrieveProfileByAgent();
}

class AuthenticationCentralized implements AuthenticationProvider {
  @override
  Future<UserProfile> loginUser(UserAuthLoginDetails details) async {
    final http.Response response = await JuntoHttp().post(
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

      // Once we authenticate the user, we can get their [UserProfile].
      final UserProfile _userData = await _retrieveUserByEmail(details.email);
      return _userData;
    } else {
      final Map<String, dynamic> errorResponse =
          JuntoHttp.handleResponse(response);
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

    final http.Response response = await JuntoHttp().post(
      '/users',
      body: _body,
    );
    final Map<String, dynamic> _responseMap =
        JuntoHttp.handleResponse(response);
    final UserData _userData = UserData.fromMap(_responseMap);
    // We need to manually login a user after their account has been create
    // to obtain an auth cookie.
    await loginUser(
      UserAuthLoginDetails(
        email: details.email,
        password: details.password,
      ),
    );
    return _userData;
  }

  @override
  Future<Map<String, dynamic>> retrieveUsernameByAgent() {
    throw UnimplementedError('This function is not supported by the '
        'centralized api.');
  }

  @override
  Future<Map<String, dynamic>> retrieveUsernameFromAddress(String address) {
    throw UnimplementedError('This function is not supported by the '
        'centralized api.');
  }

  @override
  Future<Map<String, dynamic>> retrieveProfileByAgent() {
    throw UnimplementedError('This function is not supported by the '
        'centralized api.');
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
}

@Deprecated(
    'This class uses the holochain API and thus should not be used or referanced')
class AuthenticationHolo implements AuthenticationProvider {
  /// Creates a new user on the server. Returns the user's ID if the operation is
  /// successful. Method takes [UserAuthRegistrationDetails] as its only
  /// parameter.
  @override
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
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
        // ignore: unused_local_variable
        final Map<String, dynamic> results = json.decode(response.body);

        // The user account needs to be created on holochain
        await _createHoloUser(details);

        // The results ID is returned to the user
//        return results['user_id'];
        return null;
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
  Future<UserProfile> loginUser(UserAuthLoginDetails details) async {
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
//        return responseCookie.value;
        return null;
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
  Future<Map<String, dynamic>> retrieveProfileByAgent() async {
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
