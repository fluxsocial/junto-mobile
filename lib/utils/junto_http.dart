import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

class JuntoHttp {
  JuntoHttp({
    @required this.tokenProvider,
  }) {
    httpClient = Dio(
      BaseOptions(
        baseUrl: _endPoint,
      ),
    )..interceptors.add(HeaderInterceptors(tokenProvider));

    (httpClient.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  final IdTokenProvider tokenProvider;
  final String _endPoint = END_POINT;
  Dio httpClient;

  Future<Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, String> queryParams,
  }) async {
    final _uri = '/$kServerVersion$resource';
    return httpClient.get(_uri, queryParameters: queryParams);
  }

  Future<Response> patch(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return httpClient.patch(
      '/$kServerVersion$resource',
      data: body,
    );
  }

  Future<Response> put(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return httpClient.put(
      '/$kServerVersion$resource',
      data: body,
    );
  }

  Future<Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    return httpClient.delete('/$kServerVersion$resource', data: body);
  }

  Future<Response> postWithoutEncoding(
    String resource, {
    Map<String, String> headers,
    dynamic body,
    bool authenticated = true,
  }) async {
    return httpClient.post(
      '/$kServerVersion$resource',
      data: body,
    );
  }

  static dynamic handleResponse(Response response) {
    logger.logDebug("Startus code, ${response.statusCode}");
    return response.data;
  }
}

class HeaderInterceptors extends Interceptor {
  HeaderInterceptors(this.tokenProvider) : assert(tokenProvider != null);
  final IdTokenProvider tokenProvider;
  Future<String> _getAuthKey() => tokenProvider.getIdToken();

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    options.headers.putIfAbsent("Content-Type", () => 'application/json');
    final key = await _getAuthKey();
    options.headers.putIfAbsent("Authorization", () => key);
    return SynchronousFuture(options);
  }
}
