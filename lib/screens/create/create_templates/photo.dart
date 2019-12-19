import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  const CreatePhoto({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto> {
  File imageFile;

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() => imageFile = null);
      return;
    }
    final File cropped = await ImageCroppingDialog.show(context, image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ]);
    if (cropped == null) {
      setState(() => imageFile = null);
      return;
    }
    setState(() => imageFile = cropped);
  }

  Future<void> _cropPhoto() async {
    final File image = imageFile;
    final File cropped = await ImageCroppingDialog.show(context, image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ]);
    if (cropped == null) {
      setState(() => imageFile = null);
      return;
    }
    setState(() => imageFile = cropped);
  }

  /// Creates a [CentralizedPhotoFormExpression] from the given data entered
  /// by the user.
  CentralizedPhotoFormExpression createExpression() {
    return CentralizedPhotoFormExpression(
        image: 'assets/images/junto-mobile__mock--image.png', caption: 'mossy');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: imageFile == null
            ? RaisedButton(
                onPressed: _onPickPressed,
                child: const Text('share a photo'),
              )
            : Column(
                children: <Widget>[
                  Image.file(imageFile),
                  RaisedButton(onPressed: _cropPhoto)
                ],
              ),
      ),
    );
  }
}
