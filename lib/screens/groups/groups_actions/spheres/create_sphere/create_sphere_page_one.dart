import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

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
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
      autovalidate: true,
      child: ListView(
        children: <Widget>[
          if (imageFile == null)
            GestureDetector(
              onTap: _onPickPressed,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Icon(
                  CustomIcons.camera,
                  size: 38,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          if (imageFile != null)
            Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3) * 2,
                color: Theme.of(context).dividerColor,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
              GestureDetector(
                onTap: _openChangePhotoModal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor, width: .75),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Change photo',
                          style: Theme.of(context).textTheme.caption),
                      Icon(Icons.keyboard_arrow_right,
                          color: Theme.of(context).primaryColorLight)
                    ],
                  ),
                ),
              ),
            ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  hintText: 'Name of circle ',
                  hintStyle: Theme.of(context).textTheme.subtitle1),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              maxLines: null,
              maxLength: 140,
              style: Theme.of(context).textTheme.headline6,
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  hintText: 'Unique username',
                  hintStyle: Theme.of(context).textTheme.caption),
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
            child: TextFormField(
              validator: Validator.validateNonEmpty,
              controller: widget.sphereDescriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'About',
                hintStyle: Theme.of(context).textTheme.caption,
                counterStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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
