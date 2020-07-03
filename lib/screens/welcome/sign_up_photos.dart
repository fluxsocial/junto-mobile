import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

import 'widgets/sign_up_profile_picture.dart';

class SignUpPhotos extends StatefulWidget {
  const SignUpPhotos(this.profilePicture);
  final ProfilePicture profilePicture;

  @override
  _SignUpPhotosState createState() => _SignUpPhotosState();
}

class _SignUpPhotosState extends State<SignUpPhotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => _onImageSelect(context),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 50),
                      ProfilePictureImage(
                          profilePicture: widget.profilePicture),
                      if (widget.profilePicture.file.value != null)
                        RemovePhoto(onTap: _onRemovePhoto)
                      else
                        ProfilePictureLabel(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRemovePhoto() {
    setState(() {
      widget.profilePicture.file.value = null;
      widget.profilePicture.originalFile.value = null;
    });
  }

  Future<void> _onImageSelect(BuildContext context) async {
    {
      if (widget.profilePicture.file.value == null) {
        await _onPickPressed(context);
      } else {
        await _cropPhoto(context);
      }
    }
  }

  Future<void> _onPickPressed(BuildContext context) async {
    try {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      final File image = File(pickedImage.path);

      if (image == null && widget.profilePicture.file.value == null) {
        logger.logDebug('No image selected and no profile picture exists');
        return;
      } else if (image == null && widget.profilePicture.file.value != null) {
        logger.logDebug(
            'No new image selected but profile picture already exists');
        return;
      }

      final File cropped = await ImageCroppingDialog.show(
        context,
        image,
        aspectRatios: <String>[
          '1:1',
        ],
      );
      Navigator.of(context).focusScopeNode.unfocus();
      if (cropped == null) {
        logger.logDebug('No new image selected and cropping cancelled');
        return;
      }
      setState(() {
        widget.profilePicture.file.value = cropped;
        widget.profilePicture.originalFile.value = image;
      });
    } catch (error) {
      logger.logException(error);
    }
  }

  Future<void> _cropPhoto(BuildContext context) async {
    final File cropped = await ImageCroppingDialog.show(
      context,
      widget.profilePicture.originalFile.value,
      aspectRatios: <String>[
        '1:1',
      ],
    );
    if (cropped == null) {
      return;
    }
    widget.profilePicture.file.value = cropped;
  }
}
