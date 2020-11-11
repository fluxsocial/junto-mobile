import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:meta/meta.dart';

class JuntoHttp {
  JuntoHttp({
    @required this.tokenProvider,
  }) {
    httpClient = Dio(
      BaseOptions(
        baseUrl: _endPoint,
      ),
    )
      ..interceptors.add(HeaderInterceptors(tokenProvider))
      ..interceptors.add(LoggerInterceptor());

    (httpClient.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  VoidCallback onUnAuthorized;
  final IdTokenProvider tokenProvider;
  final String _endPoint = END_POINT;
  Dio httpClient;

  Future<Response> get(
    String resource, {
    Map<String, String> headers,
    Map<String, String> queryParams,
    bool withoutServerVersion = false,
  }) async {
    String _uri;
    switch (withoutServerVersion) {
      case true:
        _uri = '$resource';
        break;
      case false:
        _uri = '/$kServerVersion$resource';
        break;
    }

    return httpClient.get(
      _uri,
      queryParameters: queryParams,
      options: appConfig.flavor == Flavor.prod
          ? Options(
              headers: {
                'host': 'api.junto.foundation',
              },
            )
          : null,
    );
  }

  Future<Response> patch(String resource,
      {Map<String, String> headers,
      Map<String, String> queryParams,
      dynamic body}) {
    return httpClient.patch(
      '/$kServerVersion$resource',
      data: body,
      options: appConfig.flavor == Flavor.prod
          ? Options(
              headers: {'host': 'api.junto.foundation'},
            )
          : null,
    );
  }

  Future<Response> put(
    String resource, {
    Map<String, dynamic> headers,
    dynamic body,
  }) async {
    final response = await httpClient.put(
      resource,
      data: body,
      options: Options(
        headers: {...headers},
      ),
    );
    return response;
  }

  Future<Response> delete(
    String resource, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    return httpClient.delete(
      '/$kServerVersion$resource',
      data: body,
      options: appConfig.flavor == Flavor.prod
          ? Options(
              headers: {'host': 'api.junto.foundation'},
            )
          : null,
    );
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
      options: appConfig.flavor == Flavor.prod
          ? Options(
              headers: {'host': 'api.junto.foundation'},
            )
          : null,
    );
  }

  static dynamic handleResponse(Response response) {
    return response.data;
  }
}

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this.onUnAuthorized);

  final VoidCallback onUnAuthorized;

  Future<DioError> onError(DioError err) async {
    final _hasError = err?.response?.statusCode == 401;
    if (_hasError && onUnAuthorized != null ||
        err.request.path.contains('/users/null')) {
      onUnAuthorized();
    }
    return err;
  }
}

class HeaderInterceptors extends Interceptor {
  HeaderInterceptors(this.tokenProvider) : assert(tokenProvider != null);
  final IdTokenProvider tokenProvider;

  Future<String> _getAuthKey() => tokenProvider.getIdToken();

  @override
  Future<RequestOptions> onRequest(RequestOptions options) async {
    if (options.method != "PUT") {
      options.headers
          .putIfAbsent("content-type", () => 'application/json; charset=utf-8');
      final key = await _getAuthKey();
      options.headers.putIfAbsent("Authorization", () => key);
    }
    return SynchronousFuture(options);
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    if (kDebugMode) {
      print('Endpoint: ${response.request.baseUrl}${response.request.path} '
          'Query Params: ${response.request.queryParameters}'
          ' Body: ${response.request.data}'
          ' Status Code: ${response.statusCode}');
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    if (kDebugMode) {
      final response = err.response;
      print('Endpoint: ${response.request.baseUrl}${response.request.path} '
          'Query Params: ${response.request.queryParameters}'
          ' Body: ${response.request.data}'
          ' Status Code: ${response.statusCode}');
    }
    return super.onError(err);
  }
}
