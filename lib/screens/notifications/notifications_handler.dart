import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/notification.dart';

class NotificationsHandler extends ChangeNotifier {
  final NotificationRepo repository;

  List<JuntoNotification> _notifications;
  List<JuntoNotification> get notifications => _notifications;

  int unreadNotificationsCount = 0;
  bool get unreadNotifications => unreadNotificationsCount == 0;

  NotificationsHandler(this.repository) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final result = await repository.getJuntoNotifications();
    if (result.wasSuccessful) {
      _notifications = result.results;
      unreadNotificationsCount = _notifications
          .where((element) => element.unread == true)
          .toList()
          .length;
      logger.logInfo('${result.results.length} notifications fetched');
      notifyListeners();
    } else {
      logger.logError('Couldn\'t fetch the notifications');
    }
  }

  Future<void> markAsRead() async {
    //TODO mark as read
  }
}
