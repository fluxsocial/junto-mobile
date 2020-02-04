import 'dart:io';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

enum ExpressionContext { Group, Collection, Collective }

class ExpressionRepo {
  ExpressionRepo(this._expressionService);

  final ExpressionService _expressionService;

  Future<CentralizedExpressionResponse> createExpression(
    CentralizedExpression expression,
    ExpressionContext context,
    String address,
  ) {
    // Server requires that channels is not null.
    assert(expression.channels != null);

    // Channels can only contain strings.
    assert(expression.channels is List<String>);

    CentralizedExpression _expression;

    if (context == ExpressionContext.Group) {
      assert(address != null);
      _expression = expression.copyWith(
        context: <String, dynamic>{
          'Group': <String, dynamic>{'address': address}
        },
      );
    } else if (context == ExpressionContext.Collection) {
      assert(address != null);
      _expression = expression.copyWith(
        context: <String, dynamic>{
          'Collection': <String, dynamic>{'address': address}
        },
      );
    } else {
      assert(address == null);
      _expression = expression.copyWith(
          context: 'Collective', channels: expression.channels);
    }
    return _expressionService.createExpression(_expression);
  }

  Future<String> createPhoto(bool isPrivate, String fileType, File file) {
    return _expressionService.createPhoto(isPrivate, fileType, file);
  }

  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) {
    // Expression address must not be null or empty.
    assert(expressionAddress != null);
    assert(expressionAddress.isNotEmpty);
    return _expressionService.getExpression(expressionAddress);
  }

  Future<Resonation> postResonation(
    String expressionAddress,
  ) {
    // Expression address must not be null or empty.
    assert(expressionAddress != null);
    assert(expressionAddress.isNotEmpty);
    return _expressionService.postResonation(expressionAddress);
  }

  Future<CentralizedExpressionResponse> postCommentExpression(
    String parentAddress,
    String type,
    Map<String, dynamic> data,
  ) {
    return _expressionService.postCommentExpression(parentAddress, type, data);
  }

  Future<List<UserProfile>> getExpressionsResonation(
    String expressionAddress,
  ) {
    return _expressionService.getExpressionsResonation(expressionAddress);
  }

  Future<QueryResults<Comment>> getExpressionsComments(
    String expressionAddress,
  ) {
    return _expressionService.getExpressionsComments(expressionAddress);
  }

  Future<QueryResults<CentralizedExpressionResponse>> getCollectiveExpressions(
      Map<String, String> params) {
    return _expressionService.getCollectiveExpressions(params);
  }

  List<CentralizedExpressionResponse> get collectiveExpressions =>
      _expressionService.collectiveExpressions;

  Future<void> deleteExpression(String address) =>
      _expressionService.deleteExpression(address);

  Future<List<Users>> addEventMember(
    String expressionAddress,
    List<UserProfile> userProfile,
    String perms,
  ) {
    final List<Map<String, String>> _users = <Map<String, String>>[];
    for (final UserProfile _profile in userProfile) {
      _users.add(<String, String>{
        'target_user': _profile.address,
        'permissions': perms
      });
    }

    return _expressionService.addEventMember(expressionAddress, _users);
  }

  Future<QueryResults<Users>> getEventMembers(
      String expressionAddress, Map<String, String> params) async {
    return _expressionService.getEventMembers(expressionAddress, params);
  }
}
