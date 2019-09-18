import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum QueryType { address, email, username }

abstract class UserProvider {
  /// Allows the user to create a [Perspective] on the server.
  Future<PerspectiveResponse> createPerspective(Perspective perspective);

  /// Adds the given user to a perspective. The perspective address and user address must be supplied.
  Future<String> addUserToPerspective(
      String perspectiveAddress, String userAddress);

  /// Similar to [addUserToPerspective], this function takes the address of the perspective and returns a list
  /// containing `'address': 'address_of_user','entry': {'username': 'username_of_user'}`
  Future<List<Map<String, dynamic>>> getUsersInPerspective(
    String perspectiveAddress,
  );

  /// Gets the user
  Future<UserData> getUser(String userAddress);

  /// Returns the [UserProfile] for the given [QueryType]
  Future<UserProfile> queryUser(String param, QueryType queryType);

  Future<List<CentralizedPerspective>> getUserPerspective(String userAddress);
}

class UserProviderCentralized implements UserProvider {
  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<PerspectiveResponse> createPerspective(Perspective perspective) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'zome': 'perspective',
      'function': 'create_perspective',
      'args': <String, String>{
        'name': perspective.name,
      },
    };

    final http.Response serverResponse =
        await JuntoHttp().post(END_POINT, body: body);
    //ignore: always_specify_types
    final responseMap = deserializeHoloJson(serverResponse.body);
    if (responseMap['result']['Ok'] != null) {
      final PerspectiveResponse perspectiveDetails =
          PerspectiveResponse.fromMap(
        responseMap['result']['Ok'],
      );
      return perspectiveDetails;
    }

    if (responseMap['error'] != null) {
      print(responseMap['error']);
      throw JuntoException(responseMap['error']);
    }

    // Should not get here.
    return null;
  }

  @override
  Future<String> addUserToPerspective(
      String perspectiveAddress, String userAddress) async {
    throw UnimplementedError('Not implemented in centralized API');
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersInPerspective(
      String perspectiveAddress) async {
    throw UnimplementedError('Not implemented in centralized API');
  }

  @override
  Future<UserData> getUser(String userAddress) async {
    final http.Response _serverResponse =
        await JuntoHttp().get('/users/$userAddress');
    final Map<String, dynamic> _resultMap =
        JuntoHttp.handleResponse(_serverResponse);
    final UserData _userData = UserData.fromMap(_resultMap);
    return _userData;
  }

  @override
  Future<UserProfile> queryUser(String param, QueryType queryType) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String authKey = _prefs.getString('auth');

    final Uri _uri = Uri.http(
      '198.199.67.10',
      '/users',
      _buildQueryParam(param, queryType),
    );

    final http.Response _serverResponse = await http.get(
      _uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'cookie': 'auth=$authKey',
      },
    );
    if (_serverResponse.statusCode == 200) {
      final Iterable<dynamic> _listData = json.decode(_serverResponse.body);

      if (_listData.isNotEmpty) {
        return UserProfile.fromMap(_listData.first);
      }
      throw const JuntoException('Unable to retrive user profile');
    }
    throw const JuntoException('Forbidden, please log out and log back in');
  }

  @override
  Future<List<CentralizedPerspective>> getUserPerspective(
      String userAddress) async {
    final http.Response response =
        await JuntoHttp().post('/users/$userAddress/perspectives');
    final List<Map<String, dynamic>> _responseMap =
        JuntoHttp.handleResponse(response);
    return _responseMap
        .map(
            (Map<String, dynamic> data) => CentralizedPerspective.fromMap(data))
        .toList(growable: false);
  }

  /// Private function which returns the correct query param for the given
  /// [QueryType]
  Map<String, dynamic> _buildQueryParam(String param, QueryType queryType) {
    if (queryType == QueryType.address) {
      return <String, String>{
        'address': param,
      };
    } else if (queryType == QueryType.email) {
      return <String, String>{
        'email': param,
      };
    } else {
      return <String, String>{
        'username': param,
      };
    }
  }
}

@Deprecated('This class is not compatible with the centralized api')
class UserProviderHolo implements UserProvider {
  static String resource = '/holochain';

  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<PerspectiveResponse> createPerspective(Perspective perspective) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'zome': 'perspective',
      'function': 'create_perspective',
      'args': <String, String>{
        'name': perspective.name,
      },
    };

    final http.Response serverResponse =
        await JuntoHttp().post(resource, body: body);
    //ignore: always_specify_types
    final responseMap = deserializeHoloJson(serverResponse.body);
    if (responseMap['result']['Ok'] != null) {
      final PerspectiveResponse perspectiveDetails =
          PerspectiveResponse.fromMap(
        responseMap['result']['Ok'],
      );
      return perspectiveDetails;
    }

    if (responseMap['error'] != null) {
      print(responseMap['error']);
      throw JuntoException(responseMap['error']);
    }

    // Should not get here.
    return null;
  }

  @override
  Future<String> addUserToPerspective(
      String perspectiveAddress, String userAddress) async {
    assert(perspectiveAddress.isNotEmpty && userAddress.isNotEmpty);
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'add_user_to_perspective',
      'perspective',
      <String, dynamic>{
        'perspective': perspectiveAddress,
        'target_user': userAddress,
      },
    );
    try {
      final http.Response _response = await JuntoHttp().post(
        resource,
        body: _body,
      );
      final String juntoResponse = JuntoHttp.handleResponse(_response);
      print(juntoResponse);
      return juntoResponse;
    } on HttpException catch (error) {
      debugPrint('Error occured in user_provider $error');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersInPerspective(
      String perspectiveAddress) async {
    assert(perspectiveAddress.isNotEmpty);
    final Map<String, dynamic> _body = JuntoHttp.holobody(
      'get_perspectives_users',
      'perspective',
      <String, dynamic>{
        'perspective': perspectiveAddress,
      },
    );
    try {
      final http.Response _response = await JuntoHttp().post(
        resource,
        body: _body,
      );
      final List<Map<String, dynamic>> juntoResponse =
          JuntoHttp.handleResponse(_response);
      print(juntoResponse);
      return juntoResponse;
    } on HttpException catch (error) {
      debugPrint('Error occured in user_provider $error');
      rethrow;
    }
  }

  @override
  Future<UserData> getUser(String userAddress) async {
    throw UnimplementedError('This functions does not exist on the Holochain '
        'API');
  }

  @override
  Future<UserProfile> queryUser(String param, QueryType queryType) {
    throw UnimplementedError('This functions does not exist on the Holochain '
        'API');
  }

  @override
  Future<List<CentralizedPerspective>> getUserPerspective(String userAddress) {
    throw UnimplementedError('This functions does not exist on the Holochain '
        'API');
  }
}
