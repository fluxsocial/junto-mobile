import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';

class UserNavigationWrapper extends StatelessWidget {
  const UserNavigationWrapper({this.notification, this.child});

  final JuntoNotification notification;
  final dynamic child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => JuntoMember(
              profile: notification.notificationType ==
                      NotificationType.GroupJoinRequest
                  ? notification.creator
                  : notification.user,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
