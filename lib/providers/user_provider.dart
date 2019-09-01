import 'dart:convert';

import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/models/perspective.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserProvider {
  Future<PerspectiveResponse> createPerspective(Perspective perspective);
}

class UserProviderImpl implements UserProvider {
  /// Creates a [Perspective] on the server. Function takes a single argument.
  @override
  Future<PerspectiveResponse> createPerspective(Perspective perspective) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const String url = '$END_POINT/holochain';

    final http.Response serverResponse = await http.post(
      Uri.encodeFull(url),
      headers: <String, String>{
        'auth': prefs.getString('auth'),
      },
      body: '{"args": {"name": ${perspective.name}}, "zome": "perspective", "function": "create_perspective"}',
    );

    final Map<String, dynamic> responseMap = json.decode(serverResponse.body);

    if (responseMap['Ok'] != null) {
      final PerspectiveResponse perspectiveDetails = PerspectiveResponse.fromMap(
        responseMap['Ok'],
      );
      return perspectiveDetails;
    }

    if (responseMap['Err'] != null) {
      throw Exception(responseMap['Err']['Error Type']);
    }

    // Should not get here.
    return null;
  }
}
