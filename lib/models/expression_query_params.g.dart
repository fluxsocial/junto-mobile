// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression_query_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExpressionQueryParams _$_$_ExpressionQueryParamsFromJson(Map json) {
  return _$_ExpressionQueryParams(
    _$enumDecodeNullable(_$ExpressionContextTypeEnumMap, json['context_type']),
    json['pagination_position'] as String,
    dos: json['dos'] as String,
    context: json['context'] as String,
    channels: (json['channels'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$_$_ExpressionQueryParamsToJson(
        _$_ExpressionQueryParams instance) =>
    <String, dynamic>{
      'context_type': _$ExpressionContextTypeEnumMap[instance.contextType],
      'pagination_position': instance.paginationPosition,
      'dos': instance.dos,
      'context': instance.context,
      'channels': ListToString.toJson(instance.channels),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ExpressionContextTypeEnumMap = {
  ExpressionContextType.Dos: 'Dos',
  ExpressionContextType.FellowPerspective: 'FellowPerspective',
  ExpressionContextType.Collective: 'Collective',
  ExpressionContextType.Group: 'Group',
  ExpressionContextType.ConnectPerspective: 'ConnectPerspective',
};
