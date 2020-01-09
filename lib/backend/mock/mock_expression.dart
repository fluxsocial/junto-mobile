import 'dart:io';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/resonation_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockExpressionService implements ExpressionService {
  @override
  List<CentralizedExpressionResponse> get collectiveExpressions =>
      kSampleExpressions;

  @override
  Future<CentralizedExpressionResponse> createExpression(
      CentralizedExpression expression) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kExpressionResponse;
  }

  @override
  Future<String> createPhoto(String fileType, File file) async {
    return 'xczxc-qwerqwe-324234';
  }

  @override
  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return kExpressionResponse;
  }

  @override
  Future<QueryCommentResults> getExpressionsComments(
      String expressionAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return QueryCommentResults(
      results: List<Comment>.generate(50, (int index) => kComment),
      lastTimestamp: DateTime(2019, 12, 19).toIso8601String(),
    );
  }

  @override
  Future<List<UserProfile>> getExpressionsResonation(
      String expressionAddress) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return List<UserProfile>.generate(12, (int index) => kUserProfile);
  }

  @override
  Future<CentralizedExpressionResponse> postCommentExpression(
    String parentAddress,
    String type,
    Map<String, dynamic> data,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kExpressionResponse;
  }

  @override
  Future<Resonation> postResonation(String expressionAddress) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kResonation;
  }

  @override
  Future<List<CentralizedExpressionResponse>> queryExpression(
      ExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return kSampleExpressions.reversed.toList();
  }

  @override
  Future<QueryExpressionResults> getCollectiveExpressions(
    Map<String, String> params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return QueryExpressionResults(
      results: kSampleExpressions,
      lastTimestamp: DateTime(
        2019,
        12,
        11,
      ).toIso8601String(),
    );
  }

  @override
  Future<void> deleteExpression(String expressionAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
