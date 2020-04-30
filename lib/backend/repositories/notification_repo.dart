import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/junto_notification_read_status.dart';
import 'package:junto_beta_mobile/models/junto_notification_results.dart';
import 'package:junto_beta_mobile/models/notification_model.dart';

class NotificationRepo {
  NotificationRepo(this.service);

  final NotificationService service;
  final String cacheReadNotificationsBoxName = 'read_notifications';
  final String cacheNotificationsBoxName = 'notifications';

  Future<NotificationResultsModel> getNotifications(NotificationQuery params) {
    return service.getNotifications(params);
  }

  Future<bool> markAsRead(List<String> addresses) async {
    try {
      if (addresses == null) {
        return false;
      }
      final box = await _getReadNotificationsBox();

      final currentCache = box.get(cacheReadNotificationsBoxName);
      if (currentCache != null) {
        // append newly read notifications to cached list
        final json = jsonDecode(currentCache);
        final status = JuntoNotificationReadStatus.fromJson(json);
        status.readNotifications.addAll(addresses);
        final uniqueList = status.readNotifications.toSet().toList();
        final newStatus =
            JuntoNotificationReadStatus(readNotifications: uniqueList);
        final newJson = jsonEncode(newStatus);
        box.put(cacheReadNotificationsBoxName, newJson);
        return true;
      } else {
        // create new list of read notifications
        final status =
            JuntoNotificationReadStatus(readNotifications: addresses);
        final json = jsonEncode(status);
        box.put(cacheReadNotificationsBoxName, json);
        return true;
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error while setting notifications as read');
      final box = await _getReadNotificationsBox();
      await box.clear();
      return false;
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
            'Retrieved ${result.results.length} notifications from API. Updating unread status');
        final updatedResult = await _updateReadNotificationsStatus(result);
        //TODO: add to cache
        return updatedResult;
      } else {
        //TODO try to return from cache
        //if not then just return failed attempt
        if (true) {
          //return cached
        } else {
          logger.logError('Couldn\'t retrieve notifications from cache');
          return JuntoNotificationResults(wasSuccessful: false);
        }
      }
      return result;
    } catch (e, s) {
      logger.logException(e, s, 'Error while retrieving notifications');
      return JuntoNotificationResults(wasSuccessful: false);
    }
  }

  Future<JuntoNotificationResults> _updateReadNotificationsStatus(
      JuntoNotificationResults response) async {
    try {
      final box = await _getReadNotificationsBox();
      final currentCache = box.get(cacheReadNotificationsBoxName);

      if (currentCache != null) {
        logger.logInfo(
            'Current cache for read notification exist. Merging current read status with new notifications');
        final json = jsonDecode(currentCache);
        final status = JuntoNotificationReadStatus.fromJson(json);

        final list = response.results;
        logger.logDebug(
            'There are ${status.readNotifications.length} read notifications in cache');
        list.forEach((element) {
          list[list.indexOf(element)] = element.copyWith(
              unread: !status.readNotifications.contains(element.address));
        });
      } else {
        logger.logInfo(
            'Current cache for read notification doesn\'t exist. Setting all notifications as unread');
        final list = response.results;
        list.forEach((element) {
          list[list.indexOf(element)] = element.copyWith(unread: true);
        });
      }
    } catch (e) {
      logger
          .logError('Error while updating the notification read status: ${e}');
    }
    return response;
  }

  Future<Box> _getReadNotificationsBox() async {
    final box = await Hive.openBox(
      cacheReadNotificationsBoxName,
      encryptionKey: key,
    );
    return box;
  }
}
