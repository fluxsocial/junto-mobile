// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'junto_notification_read_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_JuntoNotificationReadStatus _$_$_JuntoNotificationReadStatusFromJson(
    Map json) {
  return _$_JuntoNotificationReadStatus(
    readNotifications:
        (json['read_notifications'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$_$_JuntoNotificationReadStatusToJson(
        _$_JuntoNotificationReadStatus instance) =>
    <String, dynamic>{
      'read_notifications': instance.readNotifications,
    };
