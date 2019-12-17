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

  Future<List<Comment>> getExpressionsComments(
    String expressionAddress,
  ) {
    return _expressionService.getExpressionsComments(expressionAddress);
  }

  Future<QueryExpressionResults> getCollectiveExpressions(params) {
    return _expressionService.getCollectiveExpressions(params);
  }

  List<CentralizedExpressionResponse> get collectiveExpressions =>
      _expressionService.collectiveExpressions;
}
