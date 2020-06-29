// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valid_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ValidUserModel _$_$_ValidUserModelFromJson(Map json) {
  return _$_ValidUserModel(
    validEmail: json['valid_email'] as bool,
    validUsername: json['valid_username'] as bool,
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$_$_ValidUserModelToJson(_$_ValidUserModel instance) =>
    <String, dynamic>{
      'valid_email': instance.validEmail,
      'valid_username': instance.validUsername,
      'error': instance.error,
    };
