import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
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
        children: <Widget>[
          Flexible(child: Consumer<NotificationsHandler>(
            builder: (context, data, child) {
              final notifications = data.notifications;
              print(notifications);
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return NotificationTile(item: item);
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
        // TODO: Handle this case.
        break;
      case NotificationType.GroupJoinRequests:
        // TODO: Handle this case.
        break;
      case NotificationType.NewComment:
        content = NewCommentNotification(item: item);
        break;
      case NotificationType.NewSubscription:
        // TODO: Handle this case.
        break;
      case NotificationType.NewConnection:
        // TODO: Handle this case.
        break;
      case NotificationType.NewPackJoin:
        // TODO: Handle this case.
        break;
    }
    return ListTile(
      title: content ??
          Text(
            // item.notificationType.toString(),
            'hello',
            style: TextStyle(
              fontWeight:
                  item.unread == true ? FontWeight.bold : FontWeight.normal,
            ),
          ),
    );
  }
}

class NewCommentNotification extends StatelessWidget {
  final JuntoNotification item;

  const NewCommentNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '${item.user?.name} commented on your expression',
      style: TextStyle(
        fontWeight: item.unread == true ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
