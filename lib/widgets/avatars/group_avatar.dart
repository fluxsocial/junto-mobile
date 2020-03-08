import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/widgets/avatars/group_avatar_placeholder.dart';

class GroupAvatar extends StatelessWidget {
  const GroupAvatar({this.profilePicture, this.diameter});

  final String profilePicture;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return profilePicture.isNotEmpty
        ? Container(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profilePicture,
                height: diameter,
                width: diameter,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String _) {
                  return GroupAvatarPlaceholder(
                    diameter: diameter,
                  );
                },
              ),
            ),
          )
        : GroupAvatarPlaceholder(
            diameter: diameter,
          );
  }
}
