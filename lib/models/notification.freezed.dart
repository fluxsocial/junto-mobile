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
      String address,
      NotificationType notificationType,
      DateTime createdAt,
      {@JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile creator,
      bool unread}) {
    return _Notification(
      address,
      notificationType,
      createdAt,
      user: user,
      group: group,
      creator: creator,
      unread: unread,
    );
  }
}

// ignore: unused_element
const $JuntoNotification = _$JuntoNotificationTearOff();

mixin _$JuntoNotification {
  String get address;
  NotificationType get notificationType;
  DateTime get createdAt;
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  UserProfile get user;
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  Group get group;
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  UserProfile get creator;
  bool get unread;

  Map<String, dynamic> toJson();
  $JuntoNotificationCopyWith<JuntoNotification> get copyWith;
}

abstract class $JuntoNotificationCopyWith<$Res> {
  factory $JuntoNotificationCopyWith(
          JuntoNotification value, $Res Function(JuntoNotification) then) =
      _$JuntoNotificationCopyWithImpl<$Res>;
  $Res call(
      {String address,
      NotificationType notificationType,
      DateTime createdAt,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile creator,
      bool unread});
}

class _$JuntoNotificationCopyWithImpl<$Res>
    implements $JuntoNotificationCopyWith<$Res> {
  _$JuntoNotificationCopyWithImpl(this._value, this._then);

  final JuntoNotification _value;
  // ignore: unused_field
  final $Res Function(JuntoNotification) _then;

  @override
  $Res call({
    Object address = freezed,
    Object notificationType = freezed,
    Object createdAt = freezed,
    Object user = freezed,
    Object group = freezed,
    Object creator = freezed,
    Object unread = freezed,
  }) {
    return _then(_value.copyWith(
      address: address == freezed ? _value.address : address as String,
      notificationType: notificationType == freezed
          ? _value.notificationType
          : notificationType as NotificationType,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      user: user == freezed ? _value.user : user as UserProfile,
      group: group == freezed ? _value.group : group as Group,
      creator: creator == freezed ? _value.creator : creator as UserProfile,
      unread: unread == freezed ? _value.unread : unread as bool,
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
      {String address,
      NotificationType notificationType,
      DateTime createdAt,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile creator,
      bool unread});
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
    Object address = freezed,
    Object notificationType = freezed,
    Object createdAt = freezed,
    Object user = freezed,
    Object group = freezed,
    Object creator = freezed,
    Object unread = freezed,
  }) {
    return _then(_Notification(
      address == freezed ? _value.address : address as String,
      notificationType == freezed
          ? _value.notificationType
          : notificationType as NotificationType,
      createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      user: user == freezed ? _value.user : user as UserProfile,
      group: group == freezed ? _value.group : group as Group,
      creator: creator == freezed ? _value.creator : creator as UserProfile,
      unread: unread == freezed ? _value.unread : unread as bool,
    ));
  }
}

@JsonSerializable()
class _$_Notification with DiagnosticableTreeMixin implements _Notification {
  _$_Notification(
      this.address,
      this.notificationType,
      this.createdAt,
      {@JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          this.user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          this.group,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          this.creator,
      this.unread})
      : assert(address != null),
        assert(notificationType != null),
        assert(createdAt != null);

  factory _$_Notification.fromJson(Map<String, dynamic> json) =>
      _$_$_NotificationFromJson(json);

  @override
  final String address;
  @override
  final NotificationType notificationType;
  @override
  final DateTime createdAt;
  @override
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  final UserProfile user;
  @override
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  final Group group;
  @override
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  final UserProfile creator;
  @override
  final bool unread;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'JuntoNotification(address: $address, notificationType: $notificationType, createdAt: $createdAt, user: $user, group: $group, creator: $creator, unread: $unread)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'JuntoNotification'))
      ..add(DiagnosticsProperty('address', address))
      ..add(DiagnosticsProperty('notificationType', notificationType))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('group', group))
      ..add(DiagnosticsProperty('creator', creator))
      ..add(DiagnosticsProperty('unread', unread));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Notification &&
            (identical(other.address, address) ||
                const DeepCollectionEquality()
                    .equals(other.address, address)) &&
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
                const DeepCollectionEquality()
                    .equals(other.creator, creator)) &&
            (identical(other.unread, unread) ||
                const DeepCollectionEquality().equals(other.unread, unread)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(notificationType) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(group) ^
      const DeepCollectionEquality().hash(creator) ^
      const DeepCollectionEquality().hash(unread);

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
      String address,
      NotificationType notificationType,
      DateTime createdAt,
      {@JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile user,
      @JsonKey(fromJson: JuntoNotification.groupFromJson, toJson: JuntoNotification.groupToJson)
          Group group,
      @JsonKey(fromJson: JuntoNotification.userFromJson, toJson: JuntoNotification.userToJson)
          UserProfile creator,
      bool unread}) = _$_Notification;

  factory _Notification.fromJson(Map<String, dynamic> json) =
      _$_Notification.fromJson;

  @override
  String get address;
  @override
  NotificationType get notificationType;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  UserProfile get user;
  @override
  @JsonKey(
      fromJson: JuntoNotification.groupFromJson,
      toJson: JuntoNotification.groupToJson)
  Group get group;
  @override
  @JsonKey(
      fromJson: JuntoNotification.userFromJson,
      toJson: JuntoNotification.userToJson)
  UserProfile get creator;
  @override
  bool get unread;
  @override
  _$NotificationCopyWith<_Notification> get copyWith;
}
