import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';

class NotificationNavigationObserver extends NavigatorObserver {
  final NotificationsHandler notificationsHandler;

  NotificationNavigationObserver(this.notificationsHandler);
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    print('push $route from $previousRoute');
    if (route.settings?.name == 'notifications') {
      notificationsHandler.fetchNotifications();
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (previousRoute.settings?.name == 'JuntoCollective') {
      notificationsHandler.fetchNotifications();
    }
  }
}
