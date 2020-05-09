// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'expression_slim_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ExpressionSlimModel _$ExpressionSlimModelFromJson(Map<String, dynamic> json) {
  return _ExpressionSlimModel.fromJson(json);
}

class _$ExpressionSlimModelTearOff {
  const _$ExpressionSlimModelTearOff();

  _ExpressionSlimModel call(
      {@required String address,
      @required String type,
      Map<String, dynamic> expressionData,
      DateTime createdAt,
      String context}) {
    return _ExpressionSlimModel(
      address: address,
      type: type,
      expressionData: expressionData,
      createdAt: createdAt,
      context: context,
    );
  }
}

// ignore: unused_element
const $ExpressionSlimModel = _$ExpressionSlimModelTearOff();

mixin _$ExpressionSlimModel {
  String get address;
  String get type;
  Map<String, dynamic> get expressionData;
  DateTime get createdAt;
  String get context;

  Map<String, dynamic> toJson();
  $ExpressionSlimModelCopyWith<ExpressionSlimModel> get copyWith;
}

abstract class $ExpressionSlimModelCopyWith<$Res> {
  factory $ExpressionSlimModelCopyWith(
          ExpressionSlimModel value, $Res Function(ExpressionSlimModel) then) =
      _$ExpressionSlimModelCopyWithImpl<$Res>;
  $Res call(
      {String address,
      String type,
      Map<String, dynamic> expressionData,
      DateTime createdAt,
      String context});
}

class _$ExpressionSlimModelCopyWithImpl<$Res>
    implements $ExpressionSlimModelCopyWith<$Res> {
  _$ExpressionSlimModelCopyWithImpl(this._value, this._then);

  final ExpressionSlimModel _value;
  // ignore: unused_field
  final $Res Function(ExpressionSlimModel) _then;

  @override
  $Res call({
    Object address = freezed,
    Object type = freezed,
    Object expressionData = freezed,
    Object createdAt = freezed,
    Object context = freezed,
  }) {
    return _then(_value.copyWith(
      address: address == freezed ? _value.address : address as String,
      type: type == freezed ? _value.type : type as String,
      expressionData: expressionData == freezed
          ? _value.expressionData
          : expressionData as Map<String, dynamic>,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      context: context == freezed ? _value.context : context as String,
    ));
  }
}

abstract class _$ExpressionSlimModelCopyWith<$Res>
    implements $ExpressionSlimModelCopyWith<$Res> {
  factory _$ExpressionSlimModelCopyWith(_ExpressionSlimModel value,
          $Res Function(_ExpressionSlimModel) then) =
      __$ExpressionSlimModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String address,
      String type,
      Map<String, dynamic> expressionData,
      DateTime createdAt,
      String context});
}

class __$ExpressionSlimModelCopyWithImpl<$Res>
    extends _$ExpressionSlimModelCopyWithImpl<$Res>
    implements _$ExpressionSlimModelCopyWith<$Res> {
  __$ExpressionSlimModelCopyWithImpl(
      _ExpressionSlimModel _value, $Res Function(_ExpressionSlimModel) _then)
      : super(_value, (v) => _then(v as _ExpressionSlimModel));

  @override
  _ExpressionSlimModel get _value => super._value as _ExpressionSlimModel;

  @override
  $Res call({
    Object address = freezed,
    Object type = freezed,
    Object expressionData = freezed,
    Object createdAt = freezed,
    Object context = freezed,
  }) {
    return _then(_ExpressionSlimModel(
      address: address == freezed ? _value.address : address as String,
      type: type == freezed ? _value.type : type as String,
      expressionData: expressionData == freezed
          ? _value.expressionData
          : expressionData as Map<String, dynamic>,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      context: context == freezed ? _value.context : context as String,
    ));
  }
}

@JsonSerializable()
class _$_ExpressionSlimModel implements _ExpressionSlimModel {
  _$_ExpressionSlimModel(
      {@required this.address,
      @required this.type,
      this.expressionData,
      this.createdAt,
      this.context})
      : assert(address != null),
        assert(type != null);

  factory _$_ExpressionSlimModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ExpressionSlimModelFromJson(json);

  @override
  final String address;
  @override
  final String type;
  @override
  final Map<String, dynamic> expressionData;
  @override
  final DateTime createdAt;
  @override
  final String context;

  @override
  String toString() {
    return 'ExpressionSlimModel(address: $address, type: $type, expressionData: $expressionData, createdAt: $createdAt, context: $context)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ExpressionSlimModel &&
            (identical(other.address, address) ||
                const DeepCollectionEquality()
                    .equals(other.address, address)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.expressionData, expressionData) ||
                const DeepCollectionEquality()
                    .equals(other.expressionData, expressionData)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.context, context) ||
                const DeepCollectionEquality().equals(other.context, context)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(expressionData) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(context);

  @override
  _$ExpressionSlimModelCopyWith<_ExpressionSlimModel> get copyWith =>
      __$ExpressionSlimModelCopyWithImpl<_ExpressionSlimModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ExpressionSlimModelToJson(this);
  }
}

abstract class _ExpressionSlimModel implements ExpressionSlimModel {
  factory _ExpressionSlimModel(
      {@required String address,
      @required String type,
      Map<String, dynamic> expressionData,
      DateTime createdAt,
      String context}) = _$_ExpressionSlimModel;

  factory _ExpressionSlimModel.fromJson(Map<String, dynamic> json) =
      _$_ExpressionSlimModel.fromJson;

  @override
  String get address;
  @override
  String get type;
  @override
  Map<String, dynamic> get expressionData;
  @override
  DateTime get createdAt;
  @override
  String get context;
  @override
  _$ExpressionSlimModelCopyWith<_ExpressionSlimModel> get copyWith;
}
