import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';

class ProfilePictureImage extends StatelessWidget {
  const ProfilePictureImage({
    Key key,
    @required this.profilePicture,
  }) : super(key: key);

  final ProfilePicture profilePicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.width * .5,
      width: MediaQuery.of(context).size.width * .5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: _ProfileImage(profilePicture: profilePicture),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({
    Key key,
    @required this.profilePicture,
  }) : super(key: key);

  final ProfilePicture profilePicture;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return profilePicture.file.value == null
            ? Icon(
                Icons.add,
                color: Colors.white,
                size: 45,
              )
            : Image.file(
                profilePicture.file.value,
                fit: BoxFit.fitHeight,
              );
      },
      valueListenable: profilePicture.file,
    );
  }
}

class ProfilePictureLabel extends StatelessWidget {
  const ProfilePictureLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      child: Text(
        S.of(context).profile_picture,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 1.7,
        ),
      ),
    );
  }
}

class RemovePhoto extends StatelessWidget {
  const RemovePhoto({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 25,
        ),
        child: Text(
          S.of(context).welcome_remove_photo,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1.7,
          ),
        ),
      ),
    );
  }
}
