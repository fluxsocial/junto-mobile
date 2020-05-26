import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/services/hive_service.dart';
import 'package:junto_beta_mobile/models/models.dart';

/// Notifications are cached through custom adapter [JuntoNotificationAdapter]
///
/// We limit the number of notifications to 100
class NotificationRepo {
  NotificationRepo(this.service, this.dbService);

  final HiveCache dbService;
  final NotificationService service;

  final int maximumNotificationCount = 100;

  Future<bool> markAsRead() async {
    try {
      final now = DateTime.now();
      logger.logInfo('Marking notifications as read');
      await dbService.setLastReadNotificationTime(now);
      return true;
    } catch (e, s) {
      logger.logException(e, s, 'Error while setting notifications as read');
      return false;
    }
  }

  Future<void> deleteNotification(String notificationKey) async {
    try {
      await dbService.deleteNotification(notificationKey);
    } catch (e) {
      logger.logException(e);
    }
  }

  Future<JuntoNotificationResults> getJuntoNotifications({
    int page = 0,
    String lastTimestamp,
    bool connectionRequests = true,
    bool groupJoinRequests = true,
  }) async {
    try {
      final result = await service.getJuntoNotifications(
        NotificationQuery(
          groupJoinRequests: groupJoinRequests,
          connectionRequests: connectionRequests,
          paginationPosition: page,
          lastTimestamp: lastTimestamp,
        ),
      );

      if (result.wasSuccessful) {
        logger.logInfo(
            'Retrieved ${result.results.length} notifications from API. '
            'Updating read status.');

        final cache = await dbService.retrieveNotifications();
        final lastReadTime = cache.lastReadNotificationTimestamp;
        final currentNotifications =
            _updateReadStatus(result.results, lastReadTime);
        await dbService.replaceNotifications(currentNotifications);

        return result.copyWith(results: currentNotifications);
      } else {
        final cache = await dbService.retrieveNotifications();
        final current = cache.notifications;
        if (current.isNotEmpty) {
          final currentNotifications =
              _updateReadStatus(current, cache.lastReadNotificationTimestamp);
          return JuntoNotificationResults(
              wasSuccessful: true, results: currentNotifications);
        } else {
          logger.logError('Couldn\'t retrieve notifications from cache');
          return JuntoNotificationResults(wasSuccessful: false);
        }
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error while retrieving notifications');
      return JuntoNotificationResults(wasSuccessful: false);
    }
  }

  List<JuntoNotification> _updateReadStatus(
      List<JuntoNotification> results, DateTime lastReadTime) {
    final currentNotifications = results
        .map(
          (e) => e.copyWith(unread: e.createdAt.isAfter(lastReadTime)),
        )
        .toList();
    return currentNotifications;
  }
}
