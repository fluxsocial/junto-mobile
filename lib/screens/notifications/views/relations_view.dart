import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/notification_tile.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/notification_placeholder.dart';
import 'package:provider/provider.dart';

class NotificationsRelationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Consumer<NotificationsHandler>(
          builder: (context, data, child) {
            final notifications = data.notifications;
            List relationsNotifications = [];

            notifications.forEach((notification) {
              if (notification.notificationType !=
                  NotificationType.NewComment) {
                relationsNotifications.add(notification);
              }
            });

            if (relationsNotifications.isNotEmpty) {
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  if (notifications.length > 0 &&
                      item.notificationType != NotificationType.NewComment) {
                    return NotificationTile(item: item);
                  } else {
                    return SizedBox();
                  }
                },
              );
            } else {
              return NotificationPlaceholder();
            }
          },
        )),
      ],
    );
  }
}
