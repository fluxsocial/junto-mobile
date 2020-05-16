import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/screens/notifications/widgets/user_navigation_wrapper.dart';

class UserProfilePicture extends StatelessWidget {
  final JuntoNotification item;

  const UserProfilePicture({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UserNavigationWrapper(
      notification: item,
      child: MemberAvatar(
        profilePicture:
            item.notificationType == NotificationType.GroupJoinRequest
                ? item.creator.profilePicture
                : item.user.profilePicture,
        diameter: 38,
      ),
    );
  }
}
