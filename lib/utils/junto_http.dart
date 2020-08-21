import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

class JuntoHttp {
  JuntoHttp({this.httpClient, this.tokenProvider}) {
    httpClient ??= IOClient();
  }

  final IdTokenProvider tokenProvider;
  final String _endPoint = END_POINT;
  http.Client httpClient;

  Future<String> _getAuthKey() => tokenProvider.getIdToken();

  Future<Map<String, String>> _getPersistentHeaders(
      {bool authenticated = true}) async {
    return <String, String>{
      'Content-Type': 'application/json',
      if (authenticated) 'Authorization': await _getAuthKey(),
    };
  }

  String _encodeUrl(String resource) {
    assert(resource.startsWith('/'),
        'Resources should start with a forward-slash.');
    return Uri.encodeFull('$_endPoint$resource');
  }

  Future<Map<String, String>> _withPersistentHeaders(
      Map<String, String> headers,
      {bool authenticated = true}) async {
    return <String, String>{
      ...await _getPersistentHeaders(authenticated: authenticated),
      ...headers ?? const <String, String>{}
    };
  }

  Future<http.Response> get(String resource,
      {Map<String, String> headers, Map<String, String> queryParams}) async {
    Uri _uri;
    if (appConfig.flavor == Flavor.dev || appConfig.flavor == Flavor.tst) {
      _uri = Uri.http(
          END_POINT_without_prefix, '/$kServerVersion$resource', queryParams);
    } else {
      _uri = Uri.https(
          END_POINT_without_prefix, '/$kServerVersion$resource', queryParams);
    }

    return httpClient.get(
      _uri,
      headers: await _withPersistentHeaders(headers),
    );
  }

  Future<http.Response> patch(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) async {
    Uri _uri;
    if (appConfig.flavor == Flavor.dev || appConfig.flavor == Flavor.tst) {
      _uri = Uri.http(
          END_POINT_without_prefix, '/$kServerVersion$resource', queryParams);
    } else {
      _uri = Uri.https(
          END_POINT_without_prefix, '/$kServerVersion$resource', queryParams);
    }

    return httpClient.patch(
      _uri,
      headers: await _withPersistentHeaders(headers),
      body: convert.json.encode(body),
    );
  }

  Future<http.Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    final Map<String, String> header = await _withPersistentHeaders(headers);
    final http.StreamedResponse _streamedResponse = await httpClient.send(
      http.Request('DELETE', Uri.parse('$_endPoint$resource'))
        ..headers['Authorization'] = header['Authorization']
        ..headers['Content-Type'] = header['Content-Type']
        ..body = convert.json.encode(body),
    );
    return http.Response.fromStream(_streamedResponse);
  }

  Future<http.Response> postWithoutEncoding(
    String resource, {
    Map<String, String> headers,
    dynamic body,
    bool authenticated = true,
  }) async {
    final dynamic jsonBody = convert.json.encode(body);
    final fullHeaders =
        await _withPersistentHeaders(headers, authenticated: authenticated);
    return httpClient.post(
      _encodeUrl(resource),
      headers: fullHeaders,
      body: jsonBody,
    );
  }

  /// Function takes [http.Response] as the only param.
  /// The status code of the [response] is examined. Status codes matching `200`
  /// [HttpStatus.ok] are deserialized and checked to ensure the body is not empty.
  /// Empty bodies return a `null` value.
  /// Status codes matching values other than `200` are decoded and examined for
  /// the `error` key.
  static dynamic handleResponse(http.Response response) {
    logger.logDebug(
        'Response status code: ${response.statusCode} (${response.reasonPhrase})\nRequest: ${response.request}');
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final dynamic responseBody = convert.json.decode(response.body);
        if (responseBody.runtimeType == Map && responseBody['error'] != null) {
          throw JuntoException("${responseBody['error']}", response.statusCode);
        } else {
          return convert.json.decode(convert.utf8.decode(response.bodyBytes));
        }
      } else {
        return null;
      }
    } else if (response.statusCode == 401) {
      throw UnAuthorizedException();
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      if (response.body.isNotEmpty) {
        final dynamic responseBody = convert.json.decode(response.body);
        if (responseBody is Map && responseBody['error'] != null) {
          throw JuntoException("${responseBody['error']}", response.statusCode);
        } else {
          throw JuntoException(
              convert.json.decode(response.body), response.statusCode);
        }
      }
      throw JuntoException('${response?.body}', response.statusCode);
    } else if (response.statusCode >= 500) {
      throw JuntoException(response.reasonPhrase, response.statusCode);
    }
    throw JuntoException(
        "${convert.json.decode(response.body)['error']}", response.statusCode);
  }
}
