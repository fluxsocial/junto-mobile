import 'package:freezed_annotation/freezed_annotation.dart';

import 'junto_notification.dart';

part 'junto_notification_cache.freezed.dart';

@freezed
abstract class JuntoNotificationCache with _$JuntoNotificationCache {
  factory JuntoNotificationCache({
    DateTime lastReadNotificationTimestamp,
    @required List<JuntoNotification> notifications,
  }) = _JuntoNotificationCache;
}
