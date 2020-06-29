// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'valid_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ValidUserModel _$ValidUserModelFromJson(Map<String, dynamic> json) {
  return _ValidUserModel.fromJson(json);
}

class _$ValidUserModelTearOff {
  const _$ValidUserModelTearOff();

  _ValidUserModel call({bool validEmail, bool validUsername, String error}) {
    return _ValidUserModel(
      validEmail: validEmail,
      validUsername: validUsername,
      error: error,
    );
  }
}

// ignore: unused_element
const $ValidUserModel = _$ValidUserModelTearOff();

mixin _$ValidUserModel {
  bool get validEmail;
  bool get validUsername;
  String get error;

  Map<String, dynamic> toJson();
  $ValidUserModelCopyWith<ValidUserModel> get copyWith;
}

abstract class $ValidUserModelCopyWith<$Res> {
  factory $ValidUserModelCopyWith(
          ValidUserModel value, $Res Function(ValidUserModel) then) =
      _$ValidUserModelCopyWithImpl<$Res>;
  $Res call({bool validEmail, bool validUsername, String error});
}

class _$ValidUserModelCopyWithImpl<$Res>
    implements $ValidUserModelCopyWith<$Res> {
  _$ValidUserModelCopyWithImpl(this._value, this._then);

  final ValidUserModel _value;
  // ignore: unused_field
  final $Res Function(ValidUserModel) _then;

  @override
  $Res call({
    Object validEmail = freezed,
    Object validUsername = freezed,
    Object error = freezed,
  }) {
    return _then(_value.copyWith(
      validEmail:
          validEmail == freezed ? _value.validEmail : validEmail as bool,
      validUsername: validUsername == freezed
          ? _value.validUsername
          : validUsername as bool,
      error: error == freezed ? _value.error : error as String,
    ));
  }
}

abstract class _$ValidUserModelCopyWith<$Res>
    implements $ValidUserModelCopyWith<$Res> {
  factory _$ValidUserModelCopyWith(
          _ValidUserModel value, $Res Function(_ValidUserModel) then) =
      __$ValidUserModelCopyWithImpl<$Res>;
  @override
  $Res call({bool validEmail, bool validUsername, String error});
}

class __$ValidUserModelCopyWithImpl<$Res>
    extends _$ValidUserModelCopyWithImpl<$Res>
    implements _$ValidUserModelCopyWith<$Res> {
  __$ValidUserModelCopyWithImpl(
      _ValidUserModel _value, $Res Function(_ValidUserModel) _then)
      : super(_value, (v) => _then(v as _ValidUserModel));

  @override
  _ValidUserModel get _value => super._value as _ValidUserModel;

  @override
  $Res call({
    Object validEmail = freezed,
    Object validUsername = freezed,
    Object error = freezed,
  }) {
    return _then(_ValidUserModel(
      validEmail:
          validEmail == freezed ? _value.validEmail : validEmail as bool,
      validUsername: validUsername == freezed
          ? _value.validUsername
          : validUsername as bool,
      error: error == freezed ? _value.error : error as String,
    ));
  }
}

@JsonSerializable()
class _$_ValidUserModel implements _ValidUserModel {
  _$_ValidUserModel({this.validEmail, this.validUsername, this.error});

  factory _$_ValidUserModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ValidUserModelFromJson(json);

  @override
  final bool validEmail;
  @override
  final bool validUsername;
  @override
  final String error;

  @override
  String toString() {
    return 'ValidUserModel(validEmail: $validEmail, validUsername: $validUsername, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ValidUserModel &&
            (identical(other.validEmail, validEmail) ||
                const DeepCollectionEquality()
                    .equals(other.validEmail, validEmail)) &&
            (identical(other.validUsername, validUsername) ||
                const DeepCollectionEquality()
                    .equals(other.validUsername, validUsername)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(validEmail) ^
      const DeepCollectionEquality().hash(validUsername) ^
      const DeepCollectionEquality().hash(error);

  @override
  _$ValidUserModelCopyWith<_ValidUserModel> get copyWith =>
      __$ValidUserModelCopyWithImpl<_ValidUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ValidUserModelToJson(this);
  }
}

abstract class _ValidUserModel implements ValidUserModel {
  factory _ValidUserModel({bool validEmail, bool validUsername, String error}) =
      _$_ValidUserModel;

  factory _ValidUserModel.fromJson(Map<String, dynamic> json) =
      _$_ValidUserModel.fromJson;

  @override
  bool get validEmail;
  @override
  bool get validUsername;
  @override
  String get error;
  @override
  _$ValidUserModelCopyWith<_ValidUserModel> get copyWith;
}
