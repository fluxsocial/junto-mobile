import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JuntoHttp {
  JuntoHttp();

  final String _endPoint = END_POINT;

  Future<String> _getAuthKey() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('auth');
  }

  Future<Map<String, String>> _getPersistentHeaders() async {
    final String authKey = await _getAuthKey();
    return <String, String>{
      'Content-Type': 'application/json',
      'cookie': 'auth=$authKey',
    };
  }

  String _encodeUrl(String resource) {
    assert(resource.startsWith('/'),
        'Resources should start with a forward-slash.');
    return Uri.encodeFull('$_endPoint$resource');
  }

  Future<Map<String, String>> _withPersistentHeaders(
      Map<String, String> headers) async {
    return <String, String>{
      ...await _getPersistentHeaders(),
      ...headers ?? const <String, String>{}
    };
  }

  String _encodeBody(Map<String, dynamic> body) {
    return body == null ? null : serializeJsonRecursively(body);
  }

  Future<http.Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return http.get(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
    );
  }

  Future<http.Response> post(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return http.post(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
      body: _encodeBody(body),
    );
  }
}
