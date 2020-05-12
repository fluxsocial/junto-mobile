import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';

class MemberProfilePictureFull extends StatelessWidget {
  const MemberProfilePictureFull({this.profile});

  final UserData profile;

  @override
  Widget build(BuildContext context) {
    return profile.user.profilePicture.isNotEmpty
        ? CachedNetworkImage(
            cacheManager: CustomCacheManager(),
            imageUrl: profile.user.profilePicture[0],
            width: MediaQuery.of(context).size.width,
            placeholder: (BuildContext context, String _) {
              return Container(
                color: Theme.of(context).dividerColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              );
            },
            fit: BoxFit.cover,
          )
        : const SizedBox();
  }
}
