// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'junto_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Notification _$_$_NotificationFromJson(Map json) {
  return _$_Notification(
    json['address'] as String,
    _$enumDecodeNullable(_$NotificationTypeEnumMap, json['notification_type']),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    user: JuntoNotification.userFromJson(json['user'] as Map<String, dynamic>),
    group:
        JuntoNotification.groupFromJson(json['group'] as Map<String, dynamic>),
    creator:
        JuntoNotification.userFromJson(json['creator'] as Map<String, dynamic>),
    expression: json['expression'] == null
        ? null
        : ExpressionSlimModel.fromJson((json['expression'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    unread: json['unread'] as bool ?? true,
  );
}

Map<String, dynamic> _$_$_NotificationToJson(_$_Notification instance) =>
    <String, dynamic>{
      'address': instance.address,
      'notification_type': _$NotificationTypeEnumMap[instance.notificationType],
      'created_at': instance.createdAt?.toIso8601String(),
      'user': JuntoNotification.userToJson(instance.user),
      'group': JuntoNotification.groupToJson(instance.group),
      'creator': JuntoNotification.userToJson(instance.creator),
      'expression': instance.expression?.toJson(),
      'unread': instance.unread,
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
  NotificationType.ConnectionNotification: 'ConnectionNotification',
  NotificationType.GroupJoinRequests: 'GroupJoinRequests',
  NotificationType.NewComment: 'NewComment',
  NotificationType.NewSubscription: 'NewSubscription',
  NotificationType.NewConnection: 'NewConnection',
  NotificationType.NewPackJoin: 'NewPackJoin',
};
