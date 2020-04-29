// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
JuntoNotification _$JuntoNotificationFromJson(Map<String, dynamic> json) {
  return _Notification.fromJson(json);
}

class _$JuntoNotificationTearOff {
  const _$JuntoNotificationTearOff();

  _Notification call(
      NotificationType notificationType,
      DateTime createdAt,
      {@JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse creator}) {
    return _Notification(
      notificationType,
      createdAt,
      user: user,
      group: group,
      creator: creator,
    );
  }
}

// ignore: unused_element
const $JuntoNotification = _$JuntoNotificationTearOff();

mixin _$JuntoNotification {
  NotificationType get notificationType;
  DateTime get createdAt;
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  SlimUserResponse get user;
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  Group get group;
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  SlimUserResponse get creator;

  Map<String, dynamic> toJson();
  $JuntoNotificationCopyWith<JuntoNotification> get copyWith;
}

abstract class $JuntoNotificationCopyWith<$Res> {
  factory $JuntoNotificationCopyWith(
          JuntoNotification value, $Res Function(JuntoNotification) then) =
      _$JuntoNotificationCopyWithImpl<$Res>;
  $Res call(
      {NotificationType notificationType,
      DateTime createdAt,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse creator});
}

class _$JuntoNotificationCopyWithImpl<$Res>
    implements $JuntoNotificationCopyWith<$Res> {
  _$JuntoNotificationCopyWithImpl(this._value, this._then);

  final JuntoNotification _value;
  // ignore: unused_field
  final $Res Function(JuntoNotification) _then;

  @override
  $Res call({
    Object notificationType = freezed,
    Object createdAt = freezed,
    Object user = freezed,
    Object group = freezed,
    Object creator = freezed,
  }) {
    return _then(_value.copyWith(
      notificationType: notificationType == freezed
          ? _value.notificationType
          : notificationType as NotificationType,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      user: user == freezed ? _value.user : user as SlimUserResponse,
      group: group == freezed ? _value.group : group as Group,
      creator:
          creator == freezed ? _value.creator : creator as SlimUserResponse,
    ));
  }
}

abstract class _$NotificationCopyWith<$Res>
    implements $JuntoNotificationCopyWith<$Res> {
  factory _$NotificationCopyWith(
          _Notification value, $Res Function(_Notification) then) =
      __$NotificationCopyWithImpl<$Res>;
  @override
  $Res call(
      {NotificationType notificationType,
      DateTime createdAt,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse creator});
}

class __$NotificationCopyWithImpl<$Res>
    extends _$JuntoNotificationCopyWithImpl<$Res>
    implements _$NotificationCopyWith<$Res> {
  __$NotificationCopyWithImpl(
      _Notification _value, $Res Function(_Notification) _then)
      : super(_value, (v) => _then(v as _Notification));

  @override
  _Notification get _value => super._value as _Notification;

  @override
  $Res call({
    Object notificationType = freezed,
    Object createdAt = freezed,
    Object user = freezed,
    Object group = freezed,
    Object creator = freezed,
  }) {
    return _then(_Notification(
      notificationType == freezed
          ? _value.notificationType
          : notificationType as NotificationType,
      createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      user: user == freezed ? _value.user : user as SlimUserResponse,
      group: group == freezed ? _value.group : group as Group,
      creator:
          creator == freezed ? _value.creator : creator as SlimUserResponse,
    ));
  }
}

@JsonSerializable()
class _$_Notification with DiagnosticableTreeMixin implements _Notification {
  _$_Notification(
      this.notificationType,
      this.createdAt,
      {@JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          this.user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          this.group,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          this.creator})
      : assert(notificationType != null),
        assert(createdAt != null);

  factory _$_Notification.fromJson(Map<String, dynamic> json) =>
      _$_$_NotificationFromJson(json);

  @override
  final NotificationType notificationType;
  @override
  final DateTime createdAt;
  @override
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  final SlimUserResponse user;
  @override
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  final Group group;
  @override
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  final SlimUserResponse creator;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'JuntoNotification(notificationType: $notificationType, createdAt: $createdAt, user: $user, group: $group, creator: $creator)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'JuntoNotification'))
      ..add(DiagnosticsProperty('notificationType', notificationType))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('group', group))
      ..add(DiagnosticsProperty('creator', creator));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Notification &&
            (identical(other.notificationType, notificationType) ||
                const DeepCollectionEquality()
                    .equals(other.notificationType, notificationType)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.group, group) ||
                const DeepCollectionEquality().equals(other.group, group)) &&
            (identical(other.creator, creator) ||
                const DeepCollectionEquality().equals(other.creator, creator)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(notificationType) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(group) ^
      const DeepCollectionEquality().hash(creator);

  @override
  _$NotificationCopyWith<_Notification> get copyWith =>
      __$NotificationCopyWithImpl<_Notification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_NotificationToJson(this);
  }
}

abstract class _Notification implements JuntoNotification {
  factory _Notification(
      NotificationType notificationType,
      DateTime createdAt,
      {@JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.slimUserFromJson, toJson: JuntoNotification.slimUserToJson)
          SlimUserResponse creator}) = _$_Notification;

  factory _Notification.fromJson(Map<String, dynamic> json) =
      _$_Notification.fromJson;

  @override
  NotificationType get notificationType;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  SlimUserResponse get user;
  @override
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  Group get group;
  @override
  @JsonKey(
      fromJson: JuntoNotification.slimUserFromJson,
      toJson: JuntoNotification.slimUserToJson)
  SlimUserResponse get creator;
  @override
  _$NotificationCopyWith<_Notification> get copyWith;
}
