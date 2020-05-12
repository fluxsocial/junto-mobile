import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class MemberBackgroundPhoto extends StatelessWidget {
  const MemberBackgroundPhoto({this.profile});

  final UserData profile;

  @override
  Widget build(BuildContext context) {
    return ImageWrapper(
      imageUrl: profile.user.backgroundPhoto,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      placeholder: (BuildContext context, String _) {
        return Container(
          color: Theme.of(context).dividerColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2,
        );
      },
      fit: BoxFit.cover,
    );
  }
}
