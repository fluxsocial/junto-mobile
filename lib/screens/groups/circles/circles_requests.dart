import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';

import 'sphere_request.dart';

class CirclesRequests extends StatelessWidget with ListDistinct {
  const CirclesRequests({
    this.userProfile,
  });

  final UserData userProfile;

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
              List circleRequestNotifications = [];
              notifications.forEach((notification) {
                if (notification.notificationType ==
                        NotificationType.GroupJoinRequest &&
                    notification.group.groupType == 'Sphere') {
                  circleRequestNotifications.add(notification);
                }
              });

              if (notifications.length > 0) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: circleRequestNotifications.length,
                  itemBuilder: (context, index) {
                    final item = circleRequestNotifications[index];
                    if (circleRequestNotifications.length > 0) {
                      return SphereRequest(item: item);
                    }
                    return const SizedBox();
                  },
                );
              } else {
                // Add placeholder for no group join requests yet
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
