import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';

class JuntoTextSpanNav extends StatelessWidget {
  TapGestureRecognizer tapRecognizer(
      BuildContext context, JuntoNotification item) {
    return TapGestureRecognizer()
      ..onTap = () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => JuntoMember(
                profile:
                    item.notificationType == NotificationType.GroupJoinRequests
                        ? item.creator
                        : item.user,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
