import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar_placeholder.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({this.profilePicture, this.diameter});

  final List<String> profilePicture;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return profilePicture.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profilePicture[0],
                height: diameter,
                width: diameter,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String _) {
                  return MemberAvatarPlaceholder(
                    diameter: diameter,
                  );
                },
              ),
            ),
          )
        : MemberAvatarPlaceholder(
            diameter: diameter,
          );
  }
}
