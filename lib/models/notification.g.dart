// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Notification _$_$_NotificationFromJson(Map json) {
  return _$_Notification(
    _$enumDecodeNullable(_$NotificationTypeEnumMap, json['notification_type']),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    user: JuntoNotification.slimUserFromJson(
        json['user'] as Map<String, dynamic>),
    group:
        JuntoNotification.groupFromJson(json['group'] as Map<String, dynamic>),
    creator: JuntoNotification.slimUserFromJson(
        json['creator'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_NotificationToJson(_$_Notification instance) =>
    <String, dynamic>{
      'notification_type': _$NotificationTypeEnumMap[instance.notificationType],
      'created_at': instance.createdAt?.toIso8601String(),
      'user': JuntoNotification.slimUserToJson(instance.user),
      'group': JuntoNotification.groupToJson(instance.group),
      'creator': JuntoNotification.slimUserToJson(instance.creator),
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

const _$NotificationTypeEnumMap = {
  NotificationType.connectionNotification: 'connectionNotification',
  NotificationType.groupJoinRequests: 'groupJoinRequests',
  NotificationType.newComment: 'newComment',
  NotificationType.newSubscription: 'newSubscription',
  NotificationType.newConnection: 'newConnection',
  NotificationType.newPackJoin: 'newPackJoin',
};
