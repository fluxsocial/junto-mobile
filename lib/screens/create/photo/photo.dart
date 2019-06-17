import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:image_cropper/image_cropper.dart';

import './../create_actions.dart';
import './../../../custom_icons.dart';

// Create using photo form
class CreatePhoto extends StatefulWidget {
  Function toggleBottomNavVisibility;

  CreatePhoto(this.toggleBottomNavVisibility);

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

class CreatePhotoState extends State<CreatePhoto> {
  File _imageFile;
  File _croppedFile;
  bool _libraryActive = true;
  bool _cameraActive = false;

  // Function to retrieve image from source (i.e. library or camera)
  void _getImage(context, source) {
    print('hellos');

    ImagePicker.pickImage(source: source, maxWidth: 400).then((File image) {
      setState(() {
        _imageFile = image;
      });

      _cropImage(image);
      widget.toggleBottomNavVisibility();

    });
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1,
      ratioY: 1,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _croppedFile = croppedFile;
    });
  }

  // Upload Image component - rendered in _photoTypeTemplate()
  _buildUploadImage() {
    return Expanded(
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getImage(context, ImageSource.gallery);
            },
            child: Icon(CustomIcons.add, size: 100, color: Color(0xff555555)),
          ),
          SizedBox(height: 20),
          Text('UPLOAD AN IMAGE'),
        ],
      ),
    );
  }

  // Use camera component - rendered in _photoTypeTemplate()
  _buildUseCamera() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getImage(context, ImageSource.camera);
            },
            child: Text('USE CAMERA'),
          ),
        ],
      ),
    );
  }

  // Component shown to prompt user to retrieve image
  _photoTypeTemplate() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          _libraryActive ? _buildUploadImage() : _buildUseCamera(),
          Container(
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Color(0xffeeeeee), width: 1),
              )),
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * .5,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _libraryActive = true;
                              _cameraActive = false;
                            });
                          },
                          child: Text('LIBRARY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _libraryActive
                                      ? Color(0xff333333)
                                      : Color(0xff999999))))),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * .5,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _libraryActive = false;
                              _cameraActive = true;
                            });
                            _getImage(context, ImageSource.camera);
                          },
                          child: Text('CAMERA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _cameraActive
                                      ? Color(0xff333333)
                                      : Color(0xff999999)))))
                ],
              ))
        ]));
  }

  // Component once image is retrieved
  _buildImagePreview() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Image.file(_croppedFile, fit: BoxFit.fitHeight ),
            alignment: Alignment.topCenter,
          ),

        ],
      ),

      // CreateActions()

      Container(
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Color(0xffeeeeee), width: 1),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              
              GestureDetector(
                onTap: () {
                  setState(() {
                    _imageFile = null;
                    _croppedFile = null;                                
                  });
                  widget.toggleBottomNavVisibility();
                }, 
                child:                 
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(Icons.arrow_back_ios, size: 17)
                ),                
              ),

              GestureDetector(
                onTap: () {
                  _getImage(context, ImageSource.gallery);
                }, 
                child:                 
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(CustomIcons.camera, size: 17)
                ),                
              ),

              GestureDetector(
                onTap: () {
                  _cropImage(_imageFile);
                }, 
                child:                 
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(Icons.crop, size: 17)
                ),                
              ),


              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(Icons.arrow_forward_ios, size: 17)
              ),              
            ],
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            _croppedFile == null ? _photoTypeTemplate() : _buildImagePreview());
  }
}

// Caption

// Container(
//   padding: EdgeInsets.symmetric(horizontal: 10),
//   margin: EdgeInsets.only(bottom: 10),
//   child: TextField(
//     buildCounter: (BuildContext context,
//             {int currentLength, int maxLength, bool isFocused}) =>
//         null,
//     decoration: InputDecoration(
//       border: InputBorder.none,
//       hintText: 'Caption (optional)',
//     ),
//     cursorColor: JuntoPalette.juntoGrey,
//     cursorWidth: 2,
//     style: JuntoStyles.lotusLongformTitle,
//     maxLines: 1,
//     maxLength: 80,
//   ),
// ),
