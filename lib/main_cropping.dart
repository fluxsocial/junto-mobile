import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

void main() => runApp(CroppingApp());

class CroppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[50],
        primaryColorLight: Colors.grey[600],
        primaryColorDark: Colors.blue,
      ),*/
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.grey[900],
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                onPressed: _onPickPressed,
                child: const Text('Pick'),
              ),
            ),
            if (imageFile != null) ...<Widget>[
              Expanded(
                child: Center(
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
