import 'package:freezed_annotation/freezed_annotation.dart';

part 'junto_notification_read_status.freezed.dart';
part 'junto_notification_read_status.g.dart';

@freezed
abstract class JuntoNotificationReadStatus with _$JuntoNotificationReadStatus {
  factory JuntoNotificationReadStatus({
    @required List<String> readNotifications,
  }) = _JuntoNotificationReadStatus;

  factory JuntoNotificationReadStatus.fromJson(Map<String, dynamic> json) =>
      _$JuntoNotificationReadStatusFromJson(json);
}
