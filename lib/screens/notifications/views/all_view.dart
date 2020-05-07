import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/notification_tile.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/notification_placeholder.dart';
import 'package:provider/provider.dart';

class NotificationsAllView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Consumer<NotificationsHandler>(
            builder: (context, data, child) {
              final notifications = data.notifications;
              if (notifications.length > 0) {
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    if (notifications.length > 0) {
                      return NotificationTile(item: item);
                    }
                    return const SizedBox();
                  },
                );
              } else {
                return NotificationPlaceholder();
              }
            },
          ),
        ),
      ],
    );
  }
}
