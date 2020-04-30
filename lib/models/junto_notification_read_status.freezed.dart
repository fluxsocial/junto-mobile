// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'junto_notification_read_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
JuntoNotificationReadStatus _$JuntoNotificationReadStatusFromJson(
    Map<String, dynamic> json) {
  return _JuntoNotificationReadStatus.fromJson(json);
}

class _$JuntoNotificationReadStatusTearOff {
  const _$JuntoNotificationReadStatusTearOff();

  _JuntoNotificationReadStatus call(
      {@required List<String> readNotifications}) {
    return _JuntoNotificationReadStatus(
      readNotifications: readNotifications,
    );
  }
}

// ignore: unused_element
const $JuntoNotificationReadStatus = _$JuntoNotificationReadStatusTearOff();

mixin _$JuntoNotificationReadStatus {
  List<String> get readNotifications;

  Map<String, dynamic> toJson();
  $JuntoNotificationReadStatusCopyWith<JuntoNotificationReadStatus>
      get copyWith;
}

abstract class $JuntoNotificationReadStatusCopyWith<$Res> {
  factory $JuntoNotificationReadStatusCopyWith(
          JuntoNotificationReadStatus value,
          $Res Function(JuntoNotificationReadStatus) then) =
      _$JuntoNotificationReadStatusCopyWithImpl<$Res>;
  $Res call({List<String> readNotifications});
}

class _$JuntoNotificationReadStatusCopyWithImpl<$Res>
    implements $JuntoNotificationReadStatusCopyWith<$Res> {
  _$JuntoNotificationReadStatusCopyWithImpl(this._value, this._then);

  final JuntoNotificationReadStatus _value;
  // ignore: unused_field
  final $Res Function(JuntoNotificationReadStatus) _then;

  @override
  $Res call({
    Object readNotifications = freezed,
  }) {
    return _then(_value.copyWith(
      readNotifications: readNotifications == freezed
          ? _value.readNotifications
          : readNotifications as List<String>,
    ));
  }
}

abstract class _$JuntoNotificationReadStatusCopyWith<$Res>
    implements $JuntoNotificationReadStatusCopyWith<$Res> {
  factory _$JuntoNotificationReadStatusCopyWith(
          _JuntoNotificationReadStatus value,
          $Res Function(_JuntoNotificationReadStatus) then) =
      __$JuntoNotificationReadStatusCopyWithImpl<$Res>;
  @override
  $Res call({List<String> readNotifications});
}

class __$JuntoNotificationReadStatusCopyWithImpl<$Res>
    extends _$JuntoNotificationReadStatusCopyWithImpl<$Res>
    implements _$JuntoNotificationReadStatusCopyWith<$Res> {
  __$JuntoNotificationReadStatusCopyWithImpl(
      _JuntoNotificationReadStatus _value,
      $Res Function(_JuntoNotificationReadStatus) _then)
      : super(_value, (v) => _then(v as _JuntoNotificationReadStatus));

  @override
  _JuntoNotificationReadStatus get _value =>
      super._value as _JuntoNotificationReadStatus;

  @override
  $Res call({
    Object readNotifications = freezed,
  }) {
    return _then(_JuntoNotificationReadStatus(
      readNotifications: readNotifications == freezed
          ? _value.readNotifications
          : readNotifications as List<String>,
    ));
  }
}

@JsonSerializable()
class _$_JuntoNotificationReadStatus implements _JuntoNotificationReadStatus {
  _$_JuntoNotificationReadStatus({@required this.readNotifications})
      : assert(readNotifications != null);

  factory _$_JuntoNotificationReadStatus.fromJson(Map<String, dynamic> json) =>
      _$_$_JuntoNotificationReadStatusFromJson(json);

  @override
  final List<String> readNotifications;

  @override
  String toString() {
    return 'JuntoNotificationReadStatus(readNotifications: $readNotifications)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _JuntoNotificationReadStatus &&
            (identical(other.readNotifications, readNotifications) ||
                const DeepCollectionEquality()
                    .equals(other.readNotifications, readNotifications)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(readNotifications);

  @override
  _$JuntoNotificationReadStatusCopyWith<_JuntoNotificationReadStatus>
      get copyWith => __$JuntoNotificationReadStatusCopyWithImpl<
          _JuntoNotificationReadStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_JuntoNotificationReadStatusToJson(this);
  }
}

abstract class _JuntoNotificationReadStatus
    implements JuntoNotificationReadStatus {
  factory _JuntoNotificationReadStatus(
          {@required List<String> readNotifications}) =
      _$_JuntoNotificationReadStatus;

  factory _JuntoNotificationReadStatus.fromJson(Map<String, dynamic> json) =
      _$_JuntoNotificationReadStatus.fromJson;

  @override
  List<String> get readNotifications;
  @override
  _$JuntoNotificationReadStatusCopyWith<_JuntoNotificationReadStatus>
      get copyWith;
}
