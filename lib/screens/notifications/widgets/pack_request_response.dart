import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/request_response_button.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class PackRequestResponse extends StatelessWidget {
  const PackRequestResponse({this.userAddress, this.packAddress});

  final String userAddress;
  final String packAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 48),
          RequestResponseButton(
            onTap: () async {
              JuntoLoader.showLoader(
                context,
                color: Colors.white70,
              );
              await Provider.of<GroupRepo>(context, listen: false)
                  .respondToGroupRequest(packAddress, true);
              await Provider.of<NotificationsHandler>(context, listen: false)
                  .fetchNotifications();
              JuntoLoader.hide();
            },
            buttonTitle: 'Accept',
          ),
          const SizedBox(width: 10),
          RequestResponseButton(
            onTap: () async {
              JuntoLoader.showLoader(
                context,
                color: Colors.white70,
              );
              await Provider.of<GroupRepo>(context, listen: false)
                  .respondToGroupRequest(packAddress, false);
              await Provider.of<NotificationsHandler>(context, listen: false)
                  .fetchNotifications();
              JuntoLoader.hide();
            },
            buttonTitle: 'Decline',
          ),
        ],
      ),
    );
  }
}
