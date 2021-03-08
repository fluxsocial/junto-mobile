import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/form_validation.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/settings_popup.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateSpherePageOne extends StatefulWidget {
  const CreateSpherePageOne({
    Key key,
    @required this.formKey,
    @required this.sphereNameController,
    @required this.sphereHandleController,
    @required this.sphereDescriptionController,
    @required this.imageFile,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final TextEditingController sphereNameController;
  final TextEditingController sphereHandleController;
  final TextEditingController sphereDescriptionController;
  final ValueNotifier<File> imageFile;

  @override
  _CreateSpherePageOneState createState() => _CreateSpherePageOneState();
}

class _CreateSpherePageOneState extends State<CreateSpherePageOne> {
  File get imageFile => widget.imageFile.value;

  Future<void> _onPickPressed() async {
    final imagePicker = ImagePicker();
    final permission =
        Platform.isAndroid ? Permission.storage : Permission.photos;
    if (await permission.request().isGranted) {
      final pickedImage =
          await imagePicker.getImage(source: ImageSource.gallery);
      final File image = File(pickedImage.path);
      if (image == null) {
        setState(() => widget.imageFile.value = null);
        return;
      }
      final File cropped =
          await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
        '3:2',
      ]);
      if (cropped == null) {
        setState(() => widget.imageFile.value = null);
        return;
      }
      setState(() => widget.imageFile.value = cropped);
    } else {
      showDialog(
        context: context,
        builder: (context) => SettingsPopup(
          buildContext: context,
          // TODO: @Eric - Need to update the text
          text: 'Access not granted to access gallery',
          onTap: AppSettings.openAppSettings,
        ),
      );
    }
  }

  void _openChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * .1,
                        decoration: BoxDecoration(
                          color: const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _onPickPressed();
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.photo_library,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Upload new photo',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      setState(() {
                        widget.imageFile.value = null;
                      });
                      Navigator.pop(context);
                    },
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Remove photo',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: <Widget>[
          if (imageFile == null)
            GestureDetector(
              onTap: _onPickPressed,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: .75,
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Photo',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          if (imageFile != null)
            Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: _openChangePhotoModal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: .75,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Change photo',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Theme.of(context).primaryColorLight,
                      )
                    ],
                  ),
                ),
              ),
            ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereNameController,
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name*',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              maxLines: null,
              maxLength: 140,
              style: Theme.of(context).textTheme.caption,
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereHandleController,
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Username*',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
              cursorColor: Theme.of(context).primaryColorDark,
              cursorWidth: 2,
              maxLines: null,
              style: Theme.of(context).textTheme.caption,
              maxLength: 80,
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: TextFormField(
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              validator: Validator.validateNonEmpty,
              controller: widget.sphereDescriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Bio*',
                hintStyle: Theme.of(context).textTheme.caption,
              ),
              cursorColor: Theme.of(context).primaryColorDark,
              cursorWidth: 2,
              maxLines: null,
              style: Theme.of(context).textTheme.caption,
              maxLength: 1000,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}
