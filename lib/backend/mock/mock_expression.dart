import 'dart:io';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/resonation_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockExpressionService implements ExpressionService {
  @override
  List<ExpressionResponse> get collectiveExpressions => kSampleExpressions;

  @override
  Future<ExpressionResponse> createExpression(
      ExpressionModel expression) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return kExpressionResponse;
  }

  @override
  Future<String> createPhoto(bool isPrivate, String fileType, File file) async {
    return 'xczxc-qwerqwe-324234';
  }

  @override
  Future<String> createAudio(bool isPrivate, AudioFormExpression expression) async {
    return 'xczxc-qwerqwe-324234';
  }

  @override
  Future<ExpressionResponse> getExpression(
    String expressionAddress,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return kExpressionResponse;
  }

  @override
  Future<QueryResults<Comment>> getExpressionsComments(
      String expressionAddress) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    return QueryResults<Comment>(
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
  Future<ExpressionResponse> postCommentExpression(
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
  Future<List<ExpressionResponse>> queryExpression(
      ExpressionQueryParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return kSampleExpressions.reversed.toList();
  }

  @override
  Future<QueryResults<ExpressionResponse>> getCollectiveExpressions(
    Map<String, dynamic> params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return QueryResults<ExpressionResponse>(
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

  @override
  Future<List<Users>> addEventMember(
    String expressionAddress,
    List<Map<String, String>> users,
  ) async {
    return List<Users>.generate(
      12,
      (int index) => Users(
        user: kUserProfile,
        permissionLevel: index % 2 == 0 ? 'Admin' : 'Member',
      ),
    );
  }

  @override
  Future<QueryResults<Users>> getEventMembers(
      String expressionAddress, Map<String, String> params) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return QueryResults<Users>(
        results: List<Users>.generate(
          12,
          (int index) => Users(
            user: kUserProfile,
            permissionLevel: index % 2 == 0 ? 'Admin' : 'Member',
          ),
        ),
        lastTimestamp: '');
  }
}
