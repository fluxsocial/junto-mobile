import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:meta/meta.dart';

class JuntoHttp {
  JuntoHttp({
    @required this.tokenProvider,
  }) {
    _httpClient = Dio(
      BaseOptions(baseUrl: END_POINT),
    )..interceptors.add(HeaderInterceptors(tokenProvider));

    // Enable self signed certificates on staging environment
    if (appConfig.flavor == Flavor.tst) {
      (_httpClient.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  final IdTokenProvider tokenProvider;
  Dio _httpClient;

  Future<Map<String, dynamic>> fetchAppModel() async {
    final response = await _httpClient.get('/');
    return response.data as Map<String, dynamic>;
  }

  Future<Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, String> queryParams,
  }) async {
    return _httpClient.get('/$kServerVersion/$resource',
        queryParameters: queryParams);
  }

  Future<Response> patch(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return _httpClient.patch('/$kServerVersion/$resource', data: body);
  }

  Future<Response> put(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return _httpClient.put('/$kServerVersion/$resource', data: body);
  }

  Future<Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    return _httpClient.delete('/$kServerVersion/$resource', data: body);
  }

  Future<Response> postWithoutEncoding(
    String resource, {
    Map<String, String> headers,
    dynamic body,
    bool authenticated = true,
  }) async {
    return _httpClient.post('/$kServerVersion/$resource', data: body);
  }

  static dynamic handleResponse(Response response) {
    logger.logDebug("Status code, ${response.statusCode}");
    return response.data;
  }
}

class HeaderInterceptors extends Interceptor {
  HeaderInterceptors(this.tokenProvider) : assert(tokenProvider != null);
  final IdTokenProvider tokenProvider;

  Future<String> _getAuthKey() => tokenProvider.getIdToken();

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    final _token = await _getAuthKey();
    options.headers.putIfAbsent("Content-Type", () => 'application/json');
    options.headers.putIfAbsent("Authorization", () => _token);
    return SynchronousFuture(options);
  }
}
