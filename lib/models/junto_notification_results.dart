import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';

part 'junto_notification_results.freezed.dart';
part 'junto_notification_results.g.dart';

@freezed
abstract class JuntoNotificationResults with _$JuntoNotificationResults {
  factory JuntoNotificationResults(
    List<JuntoNotification> notifications, {
    bool wasSuccessful,
  }) = _JuntoNotificationResults;

  factory JuntoNotificationResults.fromJson(Map<String, dynamic> json) =>
      _$JuntoNotificationResultsFromJson(json);
}
