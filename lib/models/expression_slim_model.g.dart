// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression_slim_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExpressionSlimModel _$_$_ExpressionSlimModelFromJson(Map json) {
  return _$_ExpressionSlimModel(
    address: json['address'] as String,
    type: json['type'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    context: json['context'] as String,
  );
}

Map<String, dynamic> _$_$_ExpressionSlimModelToJson(
        _$_ExpressionSlimModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
      'context': instance.context,
    };
