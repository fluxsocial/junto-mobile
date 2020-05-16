import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Future<bool> markAsRead(List<String> addresses) async {
    try {
      if (addresses == null) {
        return false;
      }
      logger.logInfo('Marking ${addresses.length} notifications as read');
      final notifications = await dbService.retrieveNotifications();

      for (var i = 0; i < notifications.length; i++) {
        final notif = notifications[i];
        if (addresses.contains(notif.address)) {
          final newNotification = notif.copyWith(unread: false);
          notifications[i] = newNotification;
        }
      }
      await dbService.insertNotifications(notifications, overwrite: true);
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
            'Retrieved ${result.results.length} notifications from API. Updating read status');
        debugPrint(result.results.toString());

        await dbService.insertNotifications(result.results);
        final currentNotifications = await dbService.retrieveNotifications();

        return result.copyWith(
          results: currentNotifications.take(maximumNotificationCount).toList(),
        );
      } else {
        final current = await dbService.retrieveNotifications();
        if (current.isNotEmpty) {
          return JuntoNotificationResults(
              wasSuccessful: true,
              results: current.take(maximumNotificationCount).toList());
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
}
