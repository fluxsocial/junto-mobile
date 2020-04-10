import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberBio extends StatelessWidget {
  const MemberBio({this.profile});

  final UserData profile;
  @override
  Widget build(BuildContext context) {
    return profile.user.bio != '' &&
            profile.user.bio != null &&
            profile.user.bio != ' '
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (BuildContext context) =>
                      AboutMember(profile: profile),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Text(
                profile.user.bio,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          )
        : const SizedBox();
  }
}
