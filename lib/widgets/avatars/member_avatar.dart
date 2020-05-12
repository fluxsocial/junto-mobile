import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar_placeholder.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({this.profilePicture, this.diameter});

  final List<dynamic> profilePicture;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return profilePicture.isNotEmpty
        ? Container(
            child: ClipOval(
              child: ImageWrapper(
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
