import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/user_data_provider.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/comment_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/accept_connection_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/accept_pack_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/subscribed_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/connection_request_notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notification_types/pack_request_notification.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0,
          titleSpacing: 0,
          brightness: Theme.of(context).brightness,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(width: 42)
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // NotificationsTitle(),
          Expanded(child: Consumer<NotificationsHandler>(
            builder: (context, data, child) {
              final notifications = data.notifications;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  if (notifications.length > 0) {
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
      ),
    );
  }
}

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
      case NotificationType.GroupJoinRequests:
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
        // var expression =
        //     await Provider.of<ExpressionRepo>(context, listen: false)
        //         .getExpression(item.expression);
        // var userAddress =
        //     await Provider.of<UserDataProvider>(context, listen: false)
        //         .userAddress;

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => ExpressionOpen(expression, userAddress),
        //   ),
        // );
      } else {
        if (item.notificationType == NotificationType.GroupJoinRequests) {
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

class NotificationsTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
