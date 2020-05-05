import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/notification_tile.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:provider/provider.dart';

class NotificationsExpressionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Consumer<NotificationsHandler>(
          builder: (context, data, child) {
            final notifications = data.notifications;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                if (notifications.length > 0 &&
                    item.notificationType == NotificationType.NewComment) {
                  return NotificationTile(item: item);
                } else {
                  // notification placeholder
                }
                return const SizedBox();
              },
            );
          },
        )),
      ],
    );
  }
}
