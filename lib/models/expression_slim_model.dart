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

extension ExpressionImageExt on ExpressionSlimModel {
  String get imageUrl {
    final key600 = 'thumbnail600';
    final key300 = 'thumbnail300';

    if (expressionData.containsKey(key600)) {
      final value = expressionData[key600] as String;
      if (value.isNotEmpty) {
        return value;
      }
    }
    if (expressionData.containsKey(key300)) {
      final value = expressionData[key300] as String;
      if (value.isNotEmpty) {
        return value;
      }
    }
    return expressionData['image'] as String;
  }
}
