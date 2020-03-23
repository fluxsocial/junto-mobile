import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_page_title.dart';
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

  List<File> returnDetails() {
    return <File>[profilePictureOne];
  }

  Widget _buildPhotoSelector({File profilePicture}) {
    return GestureDetector(
      onTap: () async {
        await _onPickPressed();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width - 40,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: profilePicture == null
                  ? Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 60,
                    )
                  : Image.file(
                      profilePicture,
                      fit: BoxFit.fitHeight,
                    ),
            ),
            if (profilePictureOne != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    profilePictureOne = null;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Text(
                    'REMOVE PHOTO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 1.7,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null && profilePictureOne == null) {
      setState(() => profilePictureOne = null);
      return;
    } else if (image == null && profilePictureOne != null) {
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
      setState(() => profilePictureOne = null);

      return;
    }
    setState(() => profilePictureOne = cropped);
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
              const SignUpPageTitle(title: 'Add a profile picture'),
              SizedBox(height: MediaQuery.of(context).size.height * .1),
              Expanded(
                child: Center(
                  child: _buildPhotoSelector(
                    profilePicture: profilePictureOne,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
