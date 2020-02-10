import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

class SignUpPhotos extends StatefulWidget {
  const SignUpPhotos({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpPhotosState();
  }
}

class SignUpPhotosState extends State<SignUpPhotos> {
  File profilePictureOne;
  File profilePictureTwo;

  List<File> returnDetails() {
    return <File>[profilePictureOne, profilePictureTwo];
  }

  Widget _buildPhotoSelector({int profilePictureNumber, File profilePicture}) {
    return GestureDetector(
      onTap: () async {
        if (profilePictureNumber == 1) {
          await _onPickPressed(profilePictureNumber);
        } else if (profilePictureNumber == 2 && profilePictureOne != null) {
          await _onPickPressed(profilePictureNumber);
        } else {
          return;
        }
      },
      child: Container(
        color: Colors.transparent,
        // margin: const EdgeInsets.only(
        //   right: 20,
        // ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: profilePicture == null
                  ? const Text(
                      '+',
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    )
                  : Image.file(
                      profilePicture,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPickPressed(int profilePictureNumber) async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      if (profilePictureNumber == 1) {
        setState(() => profilePictureOne = null);
      } else if (profilePictureNumber == 2) {
        setState(() => profilePictureTwo = null);
      }
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '1:1',
    ]);
    Navigator.of(context).focusScopeNode.unfocus();
    if (cropped == null) {
      if (profilePictureNumber == 1) {
        setState(() => profilePictureOne = null);
      } else if (profilePictureNumber == 2) {
        setState(() => profilePictureTwo = null);
      }
      return;
    }
    if (profilePictureNumber == 1) {
      setState(() => profilePictureOne = cropped);
    } else if (profilePictureNumber == 2) {
      setState(() => profilePictureTwo = cropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text(
                  'Add a profile picture',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 140),
              Expanded(
                child: Center(
                  child: _buildPhotoSelector(
                      profilePictureNumber: 1,
                      profilePicture: profilePictureOne),
                ),
              ),
            ]),
      ),
    );
  }
}
