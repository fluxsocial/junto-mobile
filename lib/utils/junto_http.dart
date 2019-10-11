import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' show IOClient;
import 'package:junto_beta_mobile/API.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoHttp {
  JuntoHttp({this.httpClient}) {
    httpClient ??= IOClient();
  }

  final String _endPoint = END_POINT;
  http.Client httpClient;

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
    return body == null ? null : serializeHoloJson(body);
  }

  Future<http.Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return httpClient.get(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
    );
  }

  Future<http.Response> delete(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return httpClient.delete(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
    );
  }

  Future<http.Response> post(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    final String _body = _encodeBody(body);
    return httpClient.post(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
      body: _body,
    );
  }

  Future<http.Response> postWithoutEncoding(
    String resource, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    return httpClient.post(
      _encodeUrl(resource),
      headers: await _withPersistentHeaders(headers),
      body: json.encode(body),
    );
  }

  static Map<String, dynamic> holobody(
      String functionName, String zome, Map<String, dynamic> args) {
    return <String, dynamic>{
      'zome': zome,
      'function': functionName,
      'args': args
    };
  }

  /// Parses the [http.Response] sent back to the client. Function takes the response and verifies the
  /// status code.
  static dynamic handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final dynamic responseBody = json.decode(response.body);
      if (responseBody != null) {
        return responseBody;
      }
      if (responseBody['error']) {
        throw JuntoException("Something went wrong ${responseBody['error']}");
      }
      throw const JuntoException('Error occured parsing response');
    }
    if (response.statusCode == 400) {
      final Map<String, dynamic> results = json.decode(response?.body);
      throw JuntoException('Forbidden ${results['error']}');
    }
    if (response.statusCode == 500) {
      throw const JuntoException("Ooh no, our server isn't feeling so good");
    }
    throw JuntoException(
        "Oops something went wrong ${json.decode(response.body)['error']}");
  }
}
