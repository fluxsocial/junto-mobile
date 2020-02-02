import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_http.dart';
import 'package:meta/meta.dart';

/// Concrete implementation of [ExpressionService]
@immutable
class ExpressionServiceCentralized implements ExpressionService {
  const ExpressionServiceCentralized(this.client);

  final JuntoHttp client;

  @override
  List<CentralizedExpressionResponse> get collectiveExpressions =>
      <CentralizedExpressionResponse>[];

  @override
  Future<CentralizedExpressionResponse> createExpression(
      CentralizedExpression expression) async {
    final Map<String, dynamic> _postBody = expression.toMap();
    print(_postBody);
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/expressions', body: _postBody);
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);
    final CentralizedExpressionResponse response =
        CentralizedExpressionResponse.fromMap(parseData);
    return response;
  }

  @override
  Future<String> createPhoto(String fileType, File file) async {
    // denote file type and get url, headers, and key of s3 bucket
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/auth/s3', body: fileType);

    // parse response
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);

    // seralize into new headers
    final Map<String, String> newHeaders = <String, String>{
      'x-amz-acl': parseData['headers']['x-amz-acl'],
      'x-amz-meta-user_id': parseData['headers']['x-amz-meta-user_id']
    };

    // turn file into bytes
    final Uint8List fileAsBytes = file.readAsBytesSync();

    // send put request to s3 bucket with url, new headers, and file as bytes
    final http.Response _serverResponseTwo = await http.put(
      parseData['signed_url'],
      headers: newHeaders,
      body: fileAsBytes,
    );

    print(_serverResponseTwo.statusCode);
    // if successful, return the key for next steps
    if (_serverResponseTwo.statusCode == 200) {
      return parseData['key'];
    } else {
      throw JuntoException(
        _serverResponse.reasonPhrase,
        _serverResponse.statusCode,
      );
    }
  }

  @override
  Future<CentralizedExpressionResponse> postCommentExpression(
      String expressionAddress, String type, Map<String, dynamic> data) async {
    final Map<String, dynamic> _postBody = <String, dynamic>{
      'target_expression': expressionAddress,
      'type': type,
      'expression_data': data,
      'channels': <String>[]
    };
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/expressions/$expressionAddress/comments',
      body: _postBody,
    );
    final Map<String, dynamic> _parseResponse =
        JuntoHttp.handleResponse(_serverResponse);
    return CentralizedExpressionResponse.fromMap(_parseResponse);
  }

  @override
  Future<Resonation> postResonation(
    String expressionAddress,
  ) async {
    final http.Response _serverResponse = await client.postWithoutEncoding(
      '/expressions/$expressionAddress/resonations',
    );
    return Resonation.fromMap(JuntoHttp.handleResponse(_serverResponse));
  }

  @override
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    final http.Response _response =
        await client.get('/expressions/$expressionAddress');
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_response);
    return CentralizedExpressionResponse.withCommentsAndResonations(
        _decodedResponse);
  }

  @override
  Future<QueryResults<Comment>> getExpressionsComments(
      String expressionAddress) async {
    final http.Response response = await client.get(
        '/expressions/$expressionAddress/comments',
        queryParams: <String, String>{
          'pagination_position': '0',
        });
    final Map<String, dynamic> _listData = JuntoHttp.handleResponse(response);
    return QueryResults<Comment>(
      lastTimestamp: _listData['last_timestamp'],
      results: <Comment>[
        for (dynamic data in _listData['results']) Comment.fromMap(data)
      ],
    );
  }

  @override
  Future<List<UserProfile>> getExpressionsResonation(
      String expressionAddress) async {
    final http.Response response =
        await client.get('/expressions/$expressionAddress/resonations');
    final List<dynamic> _listData = json.decode(response.body);
    final List<UserProfile> _results = _listData
        .map((dynamic data) => UserProfile.fromMap(data))
        .toList(growable: false);
    return _results;
  }

  @override
  Future<List<CentralizedExpressionResponse>> queryExpression(
    ExpressionQueryParams params,
  ) {
    throw UnimplementedError(
        'Server is needed before this function can be implemented');
  }

  @override
  Future<void> deleteExpression(String expressionAddress) async {
    final http.Response _serverResponse = await client.delete(
      '/expressions/$expressionAddress',
    );
    JuntoHttp.handleResponse(_serverResponse);
  }

  @override
  Future<QueryResults<CentralizedExpressionResponse>> getCollectiveExpressions(
      Map<String, String> params) async {
    print(params);
    final http.Response response = await client.get(
      '/expressions',
      queryParams: params,
    );
    final dynamic results = JuntoHttp.handleResponse(response);
    if (results != null && results is Map<dynamic, dynamic>) {
      return QueryResults<CentralizedExpressionResponse>(
        results: <CentralizedExpressionResponse>[
          for (dynamic data in results['results'])
            CentralizedExpressionResponse.withCommentsAndResonations(data)
        ],
        lastTimestamp: results['last_timestamp'],
      );
    }
    //FIXME(Nash+Josh): The server response for a dos query does not follow the format for standard "Collective" query.
    // Both should return data using the same "query" format.
    if (results != null && results is List<dynamic>) {
      return QueryResults<CentralizedExpressionResponse>(
        results: <CentralizedExpressionResponse>[
          for (dynamic data in results)
            CentralizedExpressionResponse.withCommentsAndResonations(data)
        ],
        lastTimestamp: null,
      );
    } else {
      return QueryResults<CentralizedExpressionResponse>(
        results: <CentralizedExpressionResponse>[],
        lastTimestamp: null,
      );
    }
  }

  @override
  Future<List<Users>> addEventMember(
    String expressionAddress,
    List<Map<String, String>> users,
  ) async {
    {
      final http.Response _serverResponse = await client.postWithoutEncoding(
        '/expressions/$expressionAddress/members',
        body: users,
      );
      final List<dynamic> _data = JuntoHttp.handleResponse(_serverResponse);
      return <Users>[for (dynamic data in _data) Users.fromJson(data)];
    }
  }

  @override
  Future<QueryResults<Users>> getEventMembers(
      String expressionAddress, Map<String, String> params) async {
    final http.Response response = await client.get(
      '/expressions/$expressionAddress/members',
      queryParams: params,
    );
    final dynamic results = JuntoHttp.handleResponse(response);
    return QueryResults<Users>(
      results: <Users>[
        for (dynamic data in results['results']) Users.fromJson(data)
      ],
      lastTimestamp: results['last_timestamp'],
    );
  }
}
