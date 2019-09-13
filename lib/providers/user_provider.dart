import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

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
}

class UserProviderImpl implements UserProvider {
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

    if (responseMap['result']['Err'] != null) {
      print(responseMap['result']['Err']);
      throw Exception(responseMap['result']['Err']);
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
}
