import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/user_profile_picture.dart';
import 'package:junto_beta_mobile/screens/notifications/utils/text_span_nav.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';

class AcceptPackNotification extends StatelessWidget {
  final JuntoNotification item;

  const AcceptPackNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          UserProfilePicture(item: item),
          const SizedBox(width: 10),
          Flexible(
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer:
                          JuntoTextSpanNav().tapRecognizer(context, item),
                      text: '${item.user?.username} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(text: 'accepted your pack invitation.')
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
