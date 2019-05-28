import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker_modern/image_picker_modern.dart';

// import 'package:image_picker_modern/image_picker_modern.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // FlatButton(
        //     onPressed: () {
        //       _getImage(context, ImageSource.gallery);
        //     },
        //     child: Text('Pick an image')),
        // FlatButton(
        //     onPressed: () {
        //       _getImage(context, ImageSource.camera);
        //     },
        //     child: Text('take an image')),
        _imageFile == null
            ? Center(
                child: Column(children: [
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                  },
                  child: Icon(Icons.add_circle_outline),
                ),
                Text('UPLOAD AN IMAGE')
              ]))
            : Container(
                child: Image.file(_imageFile, fit: BoxFit.cover, height: 300))
      ],
    );
  }
}
