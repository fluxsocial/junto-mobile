import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  CreatePhoto({Key key, Function this.setBottomNav}) : super(key: key);

  final setBottomNav;

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto> {
  File imageFile;
  TextEditingController _captionController;

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
    widget.setBottomNav(false);
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
    widget.setBottomNav(false);
    print('set bottom nav');
  }

  /// Creates a [CentralizedPhotoFormExpression] from the given data entered
  /// by the user.
  CentralizedPhotoFormExpression createExpression() {
    return CentralizedPhotoFormExpression(
        image: 'assets/images/junto-mobile__mock--image.png',
        caption: _captionController.value.text);
  }

  @override
  void initState() {
    super.initState();

    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: imageFile == null
            ? Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: GestureDetector(
                  onTap: _onPickPressed,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(10000),
                        ),
                        child: Text(
                          '+',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Press here to share a photo',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17),
                      )
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Image.file(imageFile),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: TextField(
                              controller: _captionController,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: 'write a caption..',
                                border: InputBorder.none,
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              cursorWidth: 1,
                              maxLines: null,
                              style: Theme.of(context).textTheme.caption),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              imageFile = null;
                            });
                            widget.setBottomNav(true);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .5,
                            color: Colors.transparent,
                            child: Icon(Icons.keyboard_arrow_left,
                                color: Theme.of(context).primaryColor,
                                size: 28),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _cropPhoto();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .5,
                            color: Colors.transparent,
                            child: Icon(Icons.crop,
                                color: Theme.of(context).primaryColor,
                                size: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
