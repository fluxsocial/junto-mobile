import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_placeholder.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/background_photo.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPickPressed('background');
      },
      child: Stack(
        children: <Widget>[
          if (profile != null)
            if (backgroundPhotoFile == null)
              profile.user.backgroundPhoto.isNotEmpty ||
                      profile.user.backgroundPhoto != ''
                  ? MemberBackgroundPhoto(profile: profile)
                  : MemberBackgroundPlaceholder(theme: currentTheme)
            else
              Container(
                height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  backgroundPhotoFile,
                  fit: BoxFit.cover,
                ),
              ),
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
