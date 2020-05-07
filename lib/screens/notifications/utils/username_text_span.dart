import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/notifications/utils/text_span_nav.dart';

class UsernameTextspan {
  const UsernameTextspan({this.item});
  final JuntoNotification item;

  TextSpan retrieveTextSpan(BuildContext context) {
    return TextSpan(
      recognizer: JuntoTextSpanNav().tapRecognizer(context, item),
      text: item.notificationType == NotificationType.GroupJoinRequests
          ? '${item.creator.username} '
          : '${item.user?.username} ',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
