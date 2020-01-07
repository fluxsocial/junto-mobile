import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/api.dart';
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
      'Authorization': authKey,
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

  Future<http.Response> get(String resource,
      {Map<String, String> headers, Map<String, String> queryParams}) async {
    final Uri _uri = Uri.http(
        END_POINT_without_prefix, '/$kServerVersion$resource', queryParams);
    return httpClient.get(
      _uri,
      headers: await _withPersistentHeaders(headers),
    );
  }

  Future<http.Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    final Map<String, String> header = await _withPersistentHeaders(null);
    final http.StreamedResponse _streamedResponse = await httpClient.send(
      http.Request('DELETE', Uri.parse('$_endPoint$resource'))
        ..headers['Authorization'] = header['cookie']
        ..headers['Content-Type'] = header['Content-Type']
        ..body = convert.json.encode(body),
    );
    return http.Response.fromStream(_streamedResponse);
  }

  Future<http.Response> post(
    String resource, {
    Map<String, String> headers,
    dynamic body,
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
    dynamic body,
  }) async {
    final dynamic jsonBody = convert.json.encode(body);
    return httpClient.post(_encodeUrl(resource),
        headers: await _withPersistentHeaders(headers), body: jsonBody);
  }

  static Map<String, dynamic> holobody(
      String functionName, String zome, Map<String, dynamic> args) {
    return <String, dynamic>{
      'zome': zome,
      'function': functionName,
      'args': args
    };
  }

  /// Function takes [http.Response] as the only param.
  /// The status code of the [response] is examined. Status codes matching `200`
  /// [HttpStatus.ok] are deserialized and checked to ensure the body is not empty.
  /// Empty bodies return a `null` value.
  /// Status codes matching values other than `200` are decoded and examined for
  /// the `error` key.
  static dynamic handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final dynamic responseBody = convert.json.decode(response.body);
        if (responseBody.runtimeType == Map && responseBody['error'] != null) {
          throw JuntoException("${responseBody['error']}", response.statusCode);
        } else {
          return convert.json.decode(convert.utf8.decode(response.bodyBytes));
        }
      }
      throw JuntoException('${response?.body}', response.statusCode);
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      if (response.body.isNotEmpty) {
        final dynamic responseBody = convert.json.decode(response.body);
        if (responseBody.runtimeType == Map && responseBody['error'] != null) {
          throw JuntoException("${responseBody['error']}", response.statusCode);
        } else {
          return convert.json.decode(response.body);
        }
      }
      throw JuntoException('${response?.body}', response.statusCode);
    }
    if (response.statusCode >= 500) {
      throw JuntoException(
          response.reasonPhrase, response.statusCode);
    }
    throw JuntoException(
        "${convert.json.decode(response.body)['error']}", response.statusCode);
  }
}
