import 'package:freezed_annotation/freezed_annotation.dart';

part 'expression_slim_model.freezed.dart';
part 'expression_slim_model.g.dart';

enum Privacy { Private, Shared, Public }

@freezed
abstract class ExpressionSlimModel with _$ExpressionSlimModel {
  factory ExpressionSlimModel({
    @required String address,
    @required String type,
    Map<String, dynamic> expressionData,
    DateTime createdAt,
    String context,
  }) = _ExpressionSlimModel;

  factory ExpressionSlimModel.fromJson(Map<String, dynamic> json) =>
      _$ExpressionSlimModelFromJson(json);
}
