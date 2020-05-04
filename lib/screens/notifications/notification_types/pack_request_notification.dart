import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/notification.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class PackRequestNotification extends StatelessWidget {
  final JuntoNotification item;

  const PackRequestNotification({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          MemberAvatar(
            profilePicture: item.creator.profilePicture,
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
                      text: '${item.creator?.username} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(text: 'invited you to their pack.')
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
