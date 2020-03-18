// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'expression_query_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ExpressionQueryParams _$ExpressionQueryParamsFromJson(
    Map<String, dynamic> json) {
  return _ExpressionQueryParams.fromJson(json);
}

class _$ExpressionQueryParamsTearOff {
  const _$ExpressionQueryParamsTearOff();

  _ExpressionQueryParams call(
      ExpressionContextType contextType, String paginationPosition,
      {String dos,
      String context,
      @JsonKey(toJson: ListToString.toJson) List<String> channels}) {
    return _ExpressionQueryParams(
      contextType,
      paginationPosition,
      dos: dos,
      context: context,
      channels: channels,
    );
  }
}

// ignore: unused_element
const $ExpressionQueryParams = _$ExpressionQueryParamsTearOff();

mixin _$ExpressionQueryParams {
  ExpressionContextType get contextType;
  String get paginationPosition;
  String get dos;
  String get context;
  @JsonKey(toJson: ListToString.toJson)
  List<String> get channels;

  Map<String, dynamic> toJson();
  $ExpressionQueryParamsCopyWith<ExpressionQueryParams> get copyWith;
}

abstract class $ExpressionQueryParamsCopyWith<$Res> {
  factory $ExpressionQueryParamsCopyWith(ExpressionQueryParams value,
          $Res Function(ExpressionQueryParams) then) =
      _$ExpressionQueryParamsCopyWithImpl<$Res>;
  $Res call(
      {ExpressionContextType contextType,
      String paginationPosition,
      String dos,
      String context,
      @JsonKey(toJson: ListToString.toJson) List<String> channels});
}

class _$ExpressionQueryParamsCopyWithImpl<$Res>
    implements $ExpressionQueryParamsCopyWith<$Res> {
  _$ExpressionQueryParamsCopyWithImpl(this._value, this._then);

  final ExpressionQueryParams _value;
  // ignore: unused_field
  final $Res Function(ExpressionQueryParams) _then;

  @override
  $Res call({
    Object contextType = freezed,
    Object paginationPosition = freezed,
    Object dos = freezed,
    Object context = freezed,
    Object channels = freezed,
  }) {
    return _then(_value.copyWith(
      contextType: contextType == freezed
          ? _value.contextType
          : contextType as ExpressionContextType,
      paginationPosition: paginationPosition == freezed
          ? _value.paginationPosition
          : paginationPosition as String,
      dos: dos == freezed ? _value.dos : dos as String,
      context: context == freezed ? _value.context : context as String,
      channels:
          channels == freezed ? _value.channels : channels as List<String>,
    ));
  }
}

abstract class _$ExpressionQueryParamsCopyWith<$Res>
    implements $ExpressionQueryParamsCopyWith<$Res> {
  factory _$ExpressionQueryParamsCopyWith(_ExpressionQueryParams value,
          $Res Function(_ExpressionQueryParams) then) =
      __$ExpressionQueryParamsCopyWithImpl<$Res>;
  @override
  $Res call(
      {ExpressionContextType contextType,
      String paginationPosition,
      String dos,
      String context,
      @JsonKey(toJson: ListToString.toJson) List<String> channels});
}

class __$ExpressionQueryParamsCopyWithImpl<$Res>
    extends _$ExpressionQueryParamsCopyWithImpl<$Res>
    implements _$ExpressionQueryParamsCopyWith<$Res> {
  __$ExpressionQueryParamsCopyWithImpl(_ExpressionQueryParams _value,
      $Res Function(_ExpressionQueryParams) _then)
      : super(_value, (v) => _then(v as _ExpressionQueryParams));

  @override
  _ExpressionQueryParams get _value => super._value as _ExpressionQueryParams;

  @override
  $Res call({
    Object contextType = freezed,
    Object paginationPosition = freezed,
    Object dos = freezed,
    Object context = freezed,
    Object channels = freezed,
  }) {
    return _then(_ExpressionQueryParams(
      contextType == freezed
          ? _value.contextType
          : contextType as ExpressionContextType,
      paginationPosition == freezed
          ? _value.paginationPosition
          : paginationPosition as String,
      dos: dos == freezed ? _value.dos : dos as String,
      context: context == freezed ? _value.context : context as String,
      channels:
          channels == freezed ? _value.channels : channels as List<String>,
    ));
  }
}

@JsonSerializable()
class _$_ExpressionQueryParams implements _ExpressionQueryParams {
  _$_ExpressionQueryParams(this.contextType, this.paginationPosition,
      {this.dos,
      this.context,
      @JsonKey(toJson: ListToString.toJson) this.channels})
      : assert(contextType != null),
        assert(paginationPosition != null);

  factory _$_ExpressionQueryParams.fromJson(Map<String, dynamic> json) =>
      _$_$_ExpressionQueryParamsFromJson(json);

  @override
  final ExpressionContextType contextType;
  @override
  final String paginationPosition;
  @override
  final String dos;
  @override
  final String context;
  @override
  @JsonKey(toJson: ListToString.toJson)
  final List<String> channels;

  @override
  String toString() {
    return 'ExpressionQueryParams(contextType: $contextType, paginationPosition: $paginationPosition, dos: $dos, context: $context, channels: $channels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ExpressionQueryParams &&
            (identical(other.contextType, contextType) ||
                const DeepCollectionEquality()
                    .equals(other.contextType, contextType)) &&
            (identical(other.paginationPosition, paginationPosition) ||
                const DeepCollectionEquality()
                    .equals(other.paginationPosition, paginationPosition)) &&
            (identical(other.dos, dos) ||
                const DeepCollectionEquality().equals(other.dos, dos)) &&
            (identical(other.context, context) ||
                const DeepCollectionEquality()
                    .equals(other.context, context)) &&
            (identical(other.channels, channels) ||
                const DeepCollectionEquality()
                    .equals(other.channels, channels)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(contextType) ^
      const DeepCollectionEquality().hash(paginationPosition) ^
      const DeepCollectionEquality().hash(dos) ^
      const DeepCollectionEquality().hash(context) ^
      const DeepCollectionEquality().hash(channels);

  @override
  _$ExpressionQueryParamsCopyWith<_ExpressionQueryParams> get copyWith =>
      __$ExpressionQueryParamsCopyWithImpl<_ExpressionQueryParams>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ExpressionQueryParamsToJson(this);
  }
}

abstract class _ExpressionQueryParams implements ExpressionQueryParams {
  factory _ExpressionQueryParams(
          ExpressionContextType contextType, String paginationPosition,
          {String dos,
          String context,
          @JsonKey(toJson: ListToString.toJson) List<String> channels}) =
      _$_ExpressionQueryParams;

  factory _ExpressionQueryParams.fromJson(Map<String, dynamic> json) =
      _$_ExpressionQueryParams.fromJson;

  @override
  ExpressionContextType get contextType;
  @override
  String get paginationPosition;
  @override
  String get dos;
  @override
  String get context;
  @override
  @JsonKey(toJson: ListToString.toJson)
  List<String> get channels;
  @override
  _$ExpressionQueryParamsCopyWith<_ExpressionQueryParams> get copyWith;
}
