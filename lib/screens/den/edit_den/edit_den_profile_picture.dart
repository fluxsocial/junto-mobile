import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class EditDenProfilePicture extends StatelessWidget {
  const EditDenProfilePicture({
    this.userData,
    this.profilePictureFile,
    this.onPressed,
  });

  final UserData userData;
  final File profilePictureFile;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.width / 2 - 30,
      left: 10,
      child: GestureDetector(
        onTap: () {
          onPressed('profile');
        },
        child: Stack(
          children: <Widget>[
            if (userData != null && profilePictureFile == null)
              MemberAvatar(
                diameter: 60,
                profilePicture: userData.user.profilePicture,
              )
            else if (profilePictureFile != null)
              ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                  ),
                  child: Image.file(profilePictureFile),
                ),
              ),
            ClipOval(
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                width: 60.0,
                color: Colors.black38,
                child: Icon(
                  CustomIcons.camera,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
