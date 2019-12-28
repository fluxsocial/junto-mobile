import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
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
    print('hellos');
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);
    final CentralizedExpressionResponse response =
        CentralizedExpressionResponse.fromMap(parseData);
    return response;
  }

  Future createPhoto(String fileType) async {
    final http.Response _serverResponse =
        await client.postWithoutEncoding('/auth/s3', body: fileType);
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);

    final Map<String, String> newHeaders = {
      'x-amz-acl': parseData['headers']['x-amz-acl'],
      'x-amz-meta-user_id': parseData['headers']['x-amz-meta-user_id']
    };

    final http.Response _serverResponseTwo =
        await http.put(parseData['signed_url'], headers: newHeaders);
        print('yo');
    print(_serverResponseTwo.body);

    if (_serverResponseTwo.statusCode == 200) {
      return parseData['key'];
    } else {
      print('something went wrong');

      return null;
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
    final http.Response _serverResponse = await client.post(
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
  Future<QueryCommentResults> getExpressionsComments(
      String expressionAddress) async {
    final http.Response response = await client.get(
        '/expressions/$expressionAddress/comments',
        queryParams: <String, String>{
          'pagination_position': 0.toString(),
        });
    final Map<String, dynamic> _listData = json.decode(response.body);
    return QueryCommentResults(
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
  Future<QueryExpressionResults> getCollectiveExpressions(
      Map<String, String> params) async {
    final http.Response response = await client.get(
      '/expressions',
      queryParams: params,
    );
    final dynamic results = JuntoHttp.handleResponse(response);
    if (results is Map<dynamic, dynamic>) {
      return QueryExpressionResults(
        results: <CentralizedExpressionResponse>[
          for (dynamic data in results['results'])
            CentralizedExpressionResponse.withCommentsAndResonations(data)
        ],
        lastTimestamp: results['last_timestamp'],
      );
    } else {
      return QueryExpressionResults(
        results: <CentralizedExpressionResponse>[],
        lastTimestamp: null,
      );
    }
  }
}
