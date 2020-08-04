import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/profile_picture_full.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_item.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/bio_full.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member_name.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member_appbar.dart';

class AboutMember extends StatelessWidget {
  const AboutMember({this.profile});

  final UserData profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AboutMemberAppbar(profile: profile),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  MemberProfilePictureFull(profile: profile),
                  AboutMemberName(profile: profile),
                  AboutItem(
                    item: profile.user.gender,
                    icon: Icon(CustomIcons.gender,
                        size: 17, color: Theme.of(context).primaryColor),
                  ),
                  AboutItem(
                    item: profile.user.location,
                    icon: Image.asset(
                      'assets/images/junto-mobile__location.png',
                      height: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  AboutItem(
                    item: profile.user.website,
                    icon: Image.asset(
                      'assets/images/junto-mobile__link.png',
                      height: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  MemberBioFull(
                    profile: profile,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
