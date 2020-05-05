import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/widgets/notification_signal.dart';
import 'package:provider/provider.dart';

class NotificationsLunarIcon extends StatelessWidget {
  const NotificationsLunarIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsHandler>(
      builder: (context, data, child) {
        return NotificationsIcon(unread: data.unreadNotifications);
      },
    );
  }
}

class NotificationsIcon extends StatelessWidget {
  final bool unread;

  const NotificationsIcon({
    Key key,
    this.unread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Notifications',
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NotificationsScreen(),
                settings: RouteSettings(name: 'notifications')),
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                CustomIcons.moon,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (unread)
              NotificationSignal(
                top: 2,
                right: 4,
              ),
          ],
        ),
      ),
    );
  }
}
