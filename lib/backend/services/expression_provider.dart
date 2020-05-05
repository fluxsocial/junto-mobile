import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
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
  List<ExpressionResponse> get collectiveExpressions => <ExpressionResponse>[];

  @override
  Future<ExpressionResponse> createExpression(
      ExpressionModel expression) async {
    final Map<String, dynamic> _postBody = expression.toMap();
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/expressions', body: _postBody);
    logger.logDebug(_serverResponse.body);
    logger.logDebug(_serverResponse.statusCode.toString());
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);
    final ExpressionResponse response = ExpressionResponse.fromMap(parseData);
    return response;
  }

  @override
  Future<String> createPhoto(bool isPrivate, String fileType, File file) async {
    String _serverUrl;
    if (isPrivate) {
      _serverUrl = '/auth/s3?private=true';
    } else if (isPrivate == false) {
      _serverUrl = '/auth/s3?private=false';
    }
    // denote file type and get url, headers, and key of s3 bucket
    final http.Response _serverResponse =
        await client.postWithoutEncoding(_serverUrl, body: fileType);
    logger.logDebug(_serverResponse.body);
    logger.logDebug(_serverResponse.statusCode.toString());

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
  Future<String> createAudio(
      bool isPrivate, AudioFormExpression expression) async {
    logger.logDebug('Sending request to store audio file in api storage');
    String _serverUrl;
    if (isPrivate) {
      _serverUrl = '/auth/s3?private=true';
    } else if (isPrivate == false) {
      _serverUrl = '/auth/s3?private=false';
    }
    // denote file type and get url, headers, and key of s3 bucket
    final http.Response _serverResponse =
        await client.postWithoutEncoding(_serverUrl, body: '.aac');
    logger.logDebug(_serverResponse.body);
    logger.logDebug(
        'Received response from api storage, code: ${_serverResponse.statusCode}');

    // parse response
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);

    // seralize into new headers
    final Map<String, String> newHeaders = <String, String>{
      'x-amz-acl': parseData['headers']['x-amz-acl'],
      'x-amz-meta-user_id': parseData['headers']['x-amz-meta-user_id']
    };

    // turn file into bytes
    final File file = File(expression.audio);
    final Uint8List fileAsBytes = file.readAsBytesSync();

    logger.logDebug('Uploading audio file to api storage');
    // send put request to s3 bucket with url, new headers, and file as bytes
    final http.Response _serverResponseTwo = await http.put(
      parseData['signed_url'],
      headers: newHeaders,
      body: fileAsBytes,
    );

    // if successful, return the key for next steps
    if (_serverResponseTwo.statusCode == 200) {
      logger.logDebug('Successfuly uploaded audio file to api storage');
      return parseData['key'];
    } else {
      logger.logWarning('Error while uploading audio file to api storage');
      throw JuntoException(
        _serverResponse.reasonPhrase,
        _serverResponse.statusCode,
      );
    }
  }

  @override
  Future<ExpressionResponse> postCommentExpression(
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
    return ExpressionResponse.fromMap(_parseResponse);
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
  Future<ExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    final http.Response _response =
        await client.get('/expressions/$expressionAddress');
    final Map<String, dynamic> _decodedResponse =
        JuntoHttp.handleResponse(_response);
    return ExpressionResponse.withCommentsAndResonations(_decodedResponse);
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
  Future<List<ExpressionResponse>> queryExpression(
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
  Future<QueryResults<ExpressionResponse>> getCollectiveExpressions(
      Map<String, dynamic> params) async {
    final http.Response response = await client.get(
      '/expressions',
      queryParams: params,
    );
    final dynamic results = JuntoHttp.handleResponse(response);
    if (results != null && results is Map<dynamic, dynamic>) {
      return QueryResults<ExpressionResponse>(
        results: <ExpressionResponse>[
          for (dynamic data in results['results'])
            ExpressionResponse.withCommentsAndResonations(data)
        ],
        lastTimestamp: results['last_timestamp'],
      );
    }

    if (results != null && results is List<dynamic>) {
      return QueryResults<ExpressionResponse>(
        results: <ExpressionResponse>[
          for (dynamic data in results)
            ExpressionResponse.withCommentsAndResonations(data)
        ],
        lastTimestamp: null,
      );
    } else {
      return QueryResults<ExpressionResponse>(
        results: <ExpressionResponse>[],
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
