import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_photo.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';

class EditDenBackgroundPhoto extends StatelessWidget {
  const EditDenBackgroundPhoto({
    this.profile,
    this.onPickPressed,
    this.backgroundPhotoFile,
    this.currentTheme,
  });

  final UserData profile;
  final File backgroundPhotoFile;
  final Function onPickPressed;
  final String currentTheme;

  Widget _backgroundImage() {
    if (backgroundPhotoFile == null) {
      MemberBackgroundPlaceholder(theme: currentTheme);
    }
    if (backgroundPhotoFile == profile.user.profilePicture.isNotEmpty) {
      return MemberBackgroundPhoto(
        profile: profile,
      );
    }
    return MemberBackgroundPlaceholder(theme: currentTheme);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPickPressed('background');
      },
      child: Stack(
        children: <Widget>[
          if (profile != null) _backgroundImage(),
          Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            color: Colors.black38,
            child: Icon(
              CustomIcons.camera,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
