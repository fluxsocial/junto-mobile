import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberProfilePictureAvatar extends StatelessWidget {
  const MemberProfilePictureAvatar({this.profile});
  final UserData profile;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.width / 2 - 30,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute<dynamic>(
              builder: (BuildContext context) => AboutMember(
                profile: profile,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MemberAvatar(
            profilePicture: profile.user.profilePicture,
            diameter: 60,
          ),
        ),
      ),
    );
  }
}
