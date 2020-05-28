import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';

class NotificationNavigationObserver extends NavigatorObserver {
  final NotificationsHandler notificationsHandler;

  NotificationNavigationObserver(this.notificationsHandler);
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    logger.logDebug(
        'push ${route?.settings?.name} from ${previousRoute?.settings?.name}');
    if (route.settings?.name == 'JuntoCollective') {
      notificationsHandler.fetchNotifications();
    }
    if (route.settings?.name == 'notifications') {
      notificationsHandler.fetchNotifications();
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    logger.logDebug(
        'pop ${route?.settings?.name} from ${previousRoute?.settings?.name}');
    if (previousRoute.settings?.name == 'JuntoCollective' &&
        route.settings?.name != null) {
      notificationsHandler.fetchNotifications();
    }
    if (route.settings?.name == 'notifications') {
      logger.logDebug(
          'Marking notifications as read because popping from notifications screen');
      notificationsHandler.markAllAsRead();
    }
  }
}
