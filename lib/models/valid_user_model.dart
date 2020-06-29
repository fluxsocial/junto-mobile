import 'package:freezed_annotation/freezed_annotation.dart';

part 'valid_user_model.freezed.dart';
part 'valid_user_model.g.dart';

@freezed
abstract class ValidUserModel with _$ValidUserModel {
  factory ValidUserModel({
    bool validEmail,
    bool validUsername,
    String error,
  }) = _ValidUserModel;

  factory ValidUserModel.fromJson(Map<String, dynamic> json) =>
      _$ValidUserModelFromJson(json);
}
