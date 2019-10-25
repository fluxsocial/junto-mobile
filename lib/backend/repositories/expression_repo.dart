import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';

class ExpressionRepo {
  ExpressionRepo(this._expressionService);

  final ExpressionService _expressionService;

  Future<CentralizedExpressionResponse> createExpression(
    CentralizedExpression expression,
  ) {
    return _expressionService.createExpression(expression);
  }

  Future<CentralizedExpressionResponse> getExpression(
    String expressionAddress,
  ) {
    return _expressionService.getExpression(expressionAddress);
  }

  Future<Resonation> postResonation(
    String expressionAddress,
  ) {
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

  List<CentralizedExpressionResponse> get collectiveExpressions =>
      _expressionService.collectiveExpressions;
}
