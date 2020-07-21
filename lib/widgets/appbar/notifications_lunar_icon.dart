import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/widgets/notification_signal.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

class NotificationsLunarIcon extends StatelessWidget {
  const NotificationsLunarIcon({
    Key key,
    this.onGradientBackground = false,
  }) : super(key: key);

  final bool onGradientBackground;

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationsHandler, JuntoThemesProvider>(
      builder: (context, data, theme, child) {
        return Tooltip(
          message: S.of(context).notifications_title,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => NotificationsScreen(),
                  settings: RouteSettings(name: 'notifications'),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    CustomIcons.newmoon,
                    size: 20,
                    color: onGradientBackground
                        ? JuntoPalette().juntoWhite(theme: theme)
                        : Theme.of(context).primaryColor,
                  ),
                ),
                if (data.unreadNotifications)
                  NotificationSignal(
                    top: 2,
                    right: 1,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
