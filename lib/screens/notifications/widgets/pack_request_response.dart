import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/request_response_button.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:provider/provider.dart';

class PackRequestResponse extends StatelessWidget {
  const PackRequestResponse({
    this.notification,
  });

  final JuntoNotification notification;

  void _respondToRequest(BuildContext context, bool response) async {
    // show Junto loader
    JuntoLoader.showLoader(context);
    try {
      final futures = [
        Provider.of<GroupRepo>(context, listen: false)
            .respondToGroupRequest(notification.group.address, response),
        Provider.of<NotificationsHandler>(context, listen: false)
            .fetchNotifications(),
      ];

      await Future.wait(futures);
      // hide Junto loader
      await JuntoLoader.hide();
    } catch (error) {
      logger.logException(error);
      // hide Junto loader
      await JuntoLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 48),
          RequestResponseButton(
            onTap: () async {
              _respondToRequest(context, true);
            },
            buttonTitle: S.of(context).common_accept,
          ),
          const SizedBox(width: 10),
          RequestResponseButton(
            onTap: () async {
              _respondToRequest(context, false);
            },
            buttonTitle: S.of(context).common_decline,
          ),
        ],
      ),
    );
  }
}
