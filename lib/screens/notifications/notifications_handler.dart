import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/notification.dart';

class NotificationsHandler extends ChangeNotifier {
  final NotificationRepo repository;

  List<JuntoNotification> _notifications;
  List<JuntoNotification> get notifications => _notifications ?? [];

  int _unreadNotificationsCount = 0;
  bool get unreadNotifications => _unreadNotificationsCount != 0;

  NotificationsHandler(this.repository) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    print('fetching notifications');
    final result = await repository.getJuntoNotifications();
    if (result.wasSuccessful) {
      _notifications = result.results;
      _unreadNotificationsCount = _notifications
          .where((element) => element.unread != false)
          .toList()
          .length;
      logger.logInfo('${result.results.length} notifications fetched');
      notifyListeners();
    } else {
      logger.logError('Couldn\'t fetch the notifications');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final ids = _notifications?.map((e) => e.address)?.toList();
      final result = await repository.markAsRead(ids);
      if (result == true) {
        logger.logInfo('Marked notifications as read');
        _unreadNotificationsCount = 0;
        notifyListeners();
      }
    } catch (e, s) {
      logger.logException(e, s, 'Error while setting notifications as read');
    }
  }
}
