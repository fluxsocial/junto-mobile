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
    httpClient = Dio(BaseOptions(
      baseUrl: _endPoint,
    ))
      ..interceptors.add(HeaderInterceptors(tokenProvider));
  }

  final IdTokenProvider tokenProvider;
  final String _endPoint = END_POINT;
  Dio httpClient;

  Future<Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, String> queryParams,
  }) async {
    return httpClient.get(resource, queryParameters: queryParams);
  }

  Future<Response> patch(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return httpClient.patch(resource, data: body);
  }

  Future<Response> put(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return httpClient.put(resource, data: body);
  }

  Future<Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    return httpClient.delete(resource, data: body);
  }

  Future<Response> postWithoutEncoding(
    String resource, {
    Map<String, String> headers,
    dynamic body,
    bool authenticated = true,
  }) async {
    return httpClient.post(resource, data: body);
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
    options.headers
        .putIfAbsent("Authorization", () async => await _getAuthKey());
    return SynchronousFuture(options);
  }
}
