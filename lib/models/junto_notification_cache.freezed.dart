// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'junto_notification_cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$JuntoNotificationCacheTearOff {
  const _$JuntoNotificationCacheTearOff();

  _JuntoNotificationCache call(
      {DateTime lastReadNotificationTimestamp,
      @required List<JuntoNotification> notifications}) {
    return _JuntoNotificationCache(
      lastReadNotificationTimestamp: lastReadNotificationTimestamp,
      notifications: notifications,
    );
  }
}

// ignore: unused_element
const $JuntoNotificationCache = _$JuntoNotificationCacheTearOff();

mixin _$JuntoNotificationCache {
  DateTime get lastReadNotificationTimestamp;
  List<JuntoNotification> get notifications;

  $JuntoNotificationCacheCopyWith<JuntoNotificationCache> get copyWith;
}

abstract class $JuntoNotificationCacheCopyWith<$Res> {
  factory $JuntoNotificationCacheCopyWith(JuntoNotificationCache value,
          $Res Function(JuntoNotificationCache) then) =
      _$JuntoNotificationCacheCopyWithImpl<$Res>;
  $Res call(
      {DateTime lastReadNotificationTimestamp,
      List<JuntoNotification> notifications});
}

class _$JuntoNotificationCacheCopyWithImpl<$Res>
    implements $JuntoNotificationCacheCopyWith<$Res> {
  _$JuntoNotificationCacheCopyWithImpl(this._value, this._then);

  final JuntoNotificationCache _value;
  // ignore: unused_field
  final $Res Function(JuntoNotificationCache) _then;

  @override
  $Res call({
    Object lastReadNotificationTimestamp = freezed,
    Object notifications = freezed,
  }) {
    return _then(_value.copyWith(
      lastReadNotificationTimestamp: lastReadNotificationTimestamp == freezed
          ? _value.lastReadNotificationTimestamp
          : lastReadNotificationTimestamp as DateTime,
      notifications: notifications == freezed
          ? _value.notifications
          : notifications as List<JuntoNotification>,
    ));
  }
}

abstract class _$JuntoNotificationCacheCopyWith<$Res>
    implements $JuntoNotificationCacheCopyWith<$Res> {
  factory _$JuntoNotificationCacheCopyWith(_JuntoNotificationCache value,
          $Res Function(_JuntoNotificationCache) then) =
      __$JuntoNotificationCacheCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime lastReadNotificationTimestamp,
      List<JuntoNotification> notifications});
}

class __$JuntoNotificationCacheCopyWithImpl<$Res>
    extends _$JuntoNotificationCacheCopyWithImpl<$Res>
    implements _$JuntoNotificationCacheCopyWith<$Res> {
  __$JuntoNotificationCacheCopyWithImpl(_JuntoNotificationCache _value,
      $Res Function(_JuntoNotificationCache) _then)
      : super(_value, (v) => _then(v as _JuntoNotificationCache));

  @override
  _JuntoNotificationCache get _value => super._value as _JuntoNotificationCache;

  @override
  $Res call({
    Object lastReadNotificationTimestamp = freezed,
    Object notifications = freezed,
  }) {
    return _then(_JuntoNotificationCache(
      lastReadNotificationTimestamp: lastReadNotificationTimestamp == freezed
          ? _value.lastReadNotificationTimestamp
          : lastReadNotificationTimestamp as DateTime,
      notifications: notifications == freezed
          ? _value.notifications
          : notifications as List<JuntoNotification>,
    ));
  }
}

class _$_JuntoNotificationCache implements _JuntoNotificationCache {
  _$_JuntoNotificationCache(
      {this.lastReadNotificationTimestamp, @required this.notifications})
      : assert(notifications != null);

  @override
  final DateTime lastReadNotificationTimestamp;
  @override
  final List<JuntoNotification> notifications;

  @override
  String toString() {
    return 'JuntoNotificationCache(lastReadNotificationTimestamp: $lastReadNotificationTimestamp, notifications: $notifications)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _JuntoNotificationCache &&
            (identical(other.lastReadNotificationTimestamp,
                    lastReadNotificationTimestamp) ||
                const DeepCollectionEquality().equals(
                    other.lastReadNotificationTimestamp,
                    lastReadNotificationTimestamp)) &&
            (identical(other.notifications, notifications) ||
                const DeepCollectionEquality()
                    .equals(other.notifications, notifications)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(lastReadNotificationTimestamp) ^
      const DeepCollectionEquality().hash(notifications);

  @override
  _$JuntoNotificationCacheCopyWith<_JuntoNotificationCache> get copyWith =>
      __$JuntoNotificationCacheCopyWithImpl<_JuntoNotificationCache>(
          this, _$identity);
}

abstract class _JuntoNotificationCache implements JuntoNotificationCache {
  factory _JuntoNotificationCache(
          {DateTime lastReadNotificationTimestamp,
          @required List<JuntoNotification> notifications}) =
      _$_JuntoNotificationCache;

  @override
  DateTime get lastReadNotificationTimestamp;
  @override
  List<JuntoNotification> get notifications;
  @override
  _$JuntoNotificationCacheCopyWith<_JuntoNotificationCache> get copyWith;
}
