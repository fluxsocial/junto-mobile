import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/accept_connection_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/accept_pack_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/comment_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/connection_request_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/pack_request_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/subscribed_notification.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final JuntoNotification item;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (item.notificationType) {
      case NotificationType.ConnectionNotification:
        content = ConnectionRequestNotification(item: item);
        break;
      case NotificationType.GroupJoinRequest:
        content = PackRequestNotification(item: item);
        break;
      case NotificationType.NewComment:
        content = CommentNotification(item: item);
        break;
      case NotificationType.NewSubscription:
        content = SubscribedNotification(item: item);
        break;
      case NotificationType.NewConnection:
        content = AcceptConnectionNotification(item: item);
        break;
      case NotificationType.NewPackJoin:
        content = AcceptPackNotification(item: item);
        break;
    }

    void navigateTo(BuildContext context) async {
      if (item.notificationType == NotificationType.NewComment) {
        JuntoLoader.showLoader(context);

        try {
          var sourceExpression =
              await Provider.of<ExpressionRepo>(context, listen: false)
                  .getExpression(item.sourceExpression.address);

          JuntoLoader.hide();

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ExpressionOpen(
                (_) {},
                sourceExpression,
              ),
            ),
          );
        } catch (error) {
          JuntoLoader.hide();
        }
      } else {
        if (item.notificationType == NotificationType.GroupJoinRequest) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => JuntoMember(profile: item.creator),
            ),
          );
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => JuntoMember(profile: item.user),
            ),
          );
        }
      }
    }

    return GestureDetector(
      onTap: () {
        navigateTo(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.unread == true
              ? Theme.of(context).dividerColor.withOpacity(.3)
              : Theme.of(context).backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: content ?? const SizedBox(),
      ),
    );
  }
}
