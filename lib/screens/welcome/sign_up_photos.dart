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
  File profilePictureThree;

  Map<String, dynamic> returnDetails() {
    return <String, dynamic>{};
  }

  Widget _buildPhotoSelector({int profilePictureNumber, File profilePicture}) {
    return GestureDetector(
      onTap: () {
        if (profilePictureNumber == 1) {
          _onPickPressed(profilePictureNumber);
        } else if (profilePictureNumber == 2 && profilePictureOne != null) {
          _onPickPressed(profilePictureNumber);
        } else if (profilePictureNumber == 3 && profilePictureTwo != null) {
          _onPickPressed(profilePictureNumber);
        } else {
          return;
        }
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(
          right: 20,
        ),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 180,
                width: 180,
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
                      )),
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
      } else if (profilePictureNumber == 3) {
        setState(() => profilePictureThree = null);
      }
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '1:1',
    ]);
    print(cropped);
    if (cropped == null) {
      if (profilePictureNumber == 1) {
        setState(() => profilePictureOne = null);
      } else if (profilePictureNumber == 2) {
        setState(() => profilePictureTwo = null);
      } else if (profilePictureNumber == 3) {
        setState(() => profilePictureThree = null);
      }
      return;
    }
    if (profilePictureNumber == 1) {
      setState(() => profilePictureOne = cropped);
    } else if (profilePictureNumber == 2) {
      setState(() => profilePictureTwo = cropped);
    } else if (profilePictureNumber == 3) {
      setState(() => profilePictureThree = cropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text(
                  'Add up to three profile pictures',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 100),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _buildPhotoSelector(
                        profilePictureNumber: 1,
                        profilePicture: profilePictureOne),
                    _buildPhotoSelector(
                        profilePictureNumber: 2,
                        profilePicture: profilePictureTwo),
                    _buildPhotoSelector(
                        profilePictureNumber: 3,
                        profilePicture: profilePictureThree)
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
