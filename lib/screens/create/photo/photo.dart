import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  const CreatePhoto({
    Key key,
    @required this.toggleBottomNavVisibility,
    @required this.isEditing,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;
  final Function toggleBottomNavVisibility;

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto> {
  File _imageFile;
  File _croppedFile;
  bool _onFirstScreen = true;
  bool _photoEdit = false;
  bool _libraryActive = true;
  bool _cameraActive = false;

  // Function to retrieve image from source (i.e. library or camera)
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 512).then((File image) {
      setState(() {
        _imageFile = image;
      });

      _cropImage(image);

      if (_onFirstScreen) {
        widget.toggleBottomNavVisibility();
        _onFirstScreen = false;
        _photoEdit = true;
      }
    });
  }

  // Function to crop an image
  Future<void> _cropImage(File imageFile) async {
    final File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    widget.isEditing.value = true;
    setState(() {
      _croppedFile = croppedFile;
    });
  }

  // Upload Image component - rendered in _photoTypeTemplate()
  Widget _buildUploadImage() {
    return Expanded(
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getImage(
                context,
                ImageSource.gallery,
              );
            },
            child: const Icon(
              CustomIcons.add,
              size: 100,
              color: Color(
                0xff555555,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('UPLOAD AN IMAGE'),
        ],
      ),
    );
  }

  // Use camera component - rendered in _photoTypeTemplate()
  Widget _buildUseCamera() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getImage(context, ImageSource.camera);
            },
            child: const Text('USE CAMERA'),
          ),
        ],
      ),
    );
  }

  // Component shown to prompt user to retrieve image
  Widget _photoTypeTemplate() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _libraryActive ? _buildUploadImage() : _buildUseCamera(),
          Container(
            // padding: EdgeInsets.only(top: 5),
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xffeeeeee), width: 1),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * .5,
                  child: GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          _libraryActive = true;
                          _cameraActive = false;
                        },
                      );
                    },
                    child: Text(
                      'LIBRARY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _libraryActive
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * .5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _libraryActive = false;
                        _cameraActive = true;
                      });
                      _getImage(context, ImageSource.camera);
                    },
                    child: Text(
                      'CAMERA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _cameraActive
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Component once image is retrieved
  Widget _buildImageEdit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.file(
                _croppedFile,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xffeeeeee), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        _imageFile = null;
                        _croppedFile = null;
                      },
                    );
                    widget.toggleBottomNavVisibility();
                    setState(
                      () {
                        _onFirstScreen = true;
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('BACK')
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('LIBRARY')),
                ),
                GestureDetector(
                  onTap: () {
                    _cropImage(_imageFile);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('CROP')
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     setState(
                //       () {
                //         _photoEdit = false;
                //       },
                //     );
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 10),
                //     child: Icon(Icons.arrow_forward_ios, size: 17),
                //   ),
                // ),
              ],
            ))
      ],
    );
  }

  // Component once image is retrieved
  Widget _buildImageCaption() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // color: Colors.blue,
                padding: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width - 70,
                child: TextField(
                  buildCounter: (
                    BuildContext context, {
                    int currentLength,
                    int maxLength,
                    bool isFocused,
                  }) =>
                      null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a caption (optional)',
                  ),
                  cursorColor: JuntoPalette.juntoGrey,
                  cursorWidth: 2,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(
                      0xff333333,
                    ),
                  ),
                  maxLines: null,
                  maxLength: 2200,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Container(
                height: 50,
                width: 50,
                child: Image.file(_croppedFile),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xffeeeeee),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _photoEdit = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 17,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    '# CHANNELS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(
                    () {
                      _photoEdit = false;
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'CREATE',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _currentScreen(),
    );
  }

  // Render current screen conditionally
  Widget _currentScreen() {
    if (_croppedFile == null) {
      return _photoTypeTemplate();
    } else if (_croppedFile != null && _photoEdit) {
      return _buildImageEdit();
    } else if (_croppedFile != null && _photoEdit != true) {
      return _buildImageCaption();
    } else {
      return Container();
    }
  }
}
