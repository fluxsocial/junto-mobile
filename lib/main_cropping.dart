import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/settings_popup.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(CroppingApp());

class CroppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    final imagePicker = ImagePicker();
    final permission =
        Platform.isAndroid ? Permission.storage : Permission.photos;
    if (await permission.request().isGranted) {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      final File image = File(pickedImage.path);
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
    } else {
      showDialog(
        context: context,
        child: SettingsPopup(
          buildContext: context,
          // TODO: @Eric - Need to update the text
          text: 'Access not granted to access gallery',
          onTap: AppSettings.openAppSettings,
        ),
      );
    }
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
