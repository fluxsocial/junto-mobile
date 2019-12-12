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
    final Map<String, dynamic> parseData =
        JuntoHttp.handleResponse(_serverResponse);
    final CentralizedExpressionResponse response =
        CentralizedExpressionResponse.fromMap(parseData);
    return response;
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
  Future<List<Comment>> getExpressionsComments(String expressionAddress) async {
    final http.Response response =
        await client.get('/expressions/$expressionAddress/comments');
    final List<dynamic> _listData = json.decode(response.body);
    final List<Comment> _results = _listData
        .map((dynamic data) => Comment.fromMap(data))
        .toList(growable: false);
    return _results;
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
  Future<List<CentralizedExpressionResponse>> getCollectiveExpressions(
      params) async {
    // final ExpressionQueryParams query = ExpressionQueryParams(channels: [], dos: params['dos'], context: params['contextId'], contextType: params['contextType']);
    final Map<String, String> query = <String, String>{
      'context_type': params['contextType'],
      'context': params['contextId'],
      'channel[0]': '1',
      'dos': params['dos']
    };
    final http.Response response = await client.get(
      '/expressions',
      queryParams: query,
    );
    print('got collective expressions !');
    final List<dynamic> results = JuntoHttp.handleResponse(response);
    return results
        .map(
          (dynamic data) =>
              CentralizedExpressionResponse.withCommentsAndResonations(data),
        )
        .toList(growable: false);
  }
}
