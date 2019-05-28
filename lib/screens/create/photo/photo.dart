import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

import './../../../custom_icons.dart';

class CreatePhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

class CreatePhotoState extends State<CreatePhoto> {
  File _imageFile;

  void _getImage(context, source) {
    print('hellos');

    ImagePicker.pickImage(source: source, maxWidth: 400).then((File image) {
      setState(() {
        _imageFile = image;
      });
    });
  }

  _buildUploadImage() {
    return 
        Center(
          child: Column(children: [
          GestureDetector(
            onTap: () {
              _getImage(context, ImageSource.gallery);
            },
            child: Icon(CustomIcons.add),
          ),
          Text('UPLOAD AN IMAGE')
        ]));    
  }

  _buildImagePreview() {
    Container(
      child: Image.file(_imageFile, fit: BoxFit.cover, height: 300),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        _imageFile == null
            ? _buildUploadImage()
            : _buildImagePreview()
      ],
    );
  }
}
