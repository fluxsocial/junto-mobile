// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'junto_notification_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_JuntoNotificationResults _$_$_JuntoNotificationResultsFromJson(Map json) {
  return _$_JuntoNotificationResults(
    results: (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : JuntoNotification.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    lastTimestamp: json['last_timestamp'] as String,
    resultCount: json['result_count'] as int,
    wasSuccessful: json['was_successful'] as bool,
  );
}

Map<String, dynamic> _$_$_JuntoNotificationResultsToJson(
        _$_JuntoNotificationResults instance) =>
    <String, dynamic>{
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
      'last_timestamp': instance.lastTimestamp,
      'result_count': instance.resultCount,
      'was_successful': instance.wasSuccessful,
    };
