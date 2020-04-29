// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'junto_notification_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_JuntoNotificationResults _$_$_JuntoNotificationResultsFromJson(Map json) {
  return _$_JuntoNotificationResults(
    (json['notifications'] as List)
        ?.map((e) => e == null
            ? null
            : JuntoNotification.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    wasSuccessful: json['was_successful'] as bool,
  );
}

Map<String, dynamic> _$_$_JuntoNotificationResultsToJson(
        _$_JuntoNotificationResults instance) =>
    <String, dynamic>{
      'notifications':
          instance.notifications?.map((e) => e?.toJson())?.toList(),
      'was_successful': instance.wasSuccessful,
    };
