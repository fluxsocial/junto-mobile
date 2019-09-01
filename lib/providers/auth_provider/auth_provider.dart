import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/models/user_model.dart';

/// Abstract class which defines the functionality of the Authentication Provider
abstract class AuthenticationProvider {
  Future<String> registerUser(UserAuthRegistrationDetails details);
  Future<void> loginUser(UserAuthLoginDetails details);
}

/// Concrete implementation of [AuthenticationProvider].
class AuthenticationImp implements AuthenticationProvider {
  static const String END_POINT = 'http://159.203.188.223';

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

  @override
  Future<void> loginUser(UserAuthLoginDetails details) {
    assert(details.isComplete);
    // TODO: implement loginUser
    return null;
  }
}
