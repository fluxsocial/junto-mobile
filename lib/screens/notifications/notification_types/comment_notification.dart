import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:provider/provider.dart';

class NewCommentNotification extends StatelessWidget {
  final JuntoNotification item;

  const NewCommentNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          MemberAvatar(
            profilePicture: item.user.profilePicture,
            diameter: 38,
          ),
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
                      text: '${item.user?.username} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(text: 'commented on your expression')
                  ]),
            ),
          ),
          // Flexible(
          //             child: Text(
          //     '${item.user?.username} ',
          //     style: TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w700,
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
