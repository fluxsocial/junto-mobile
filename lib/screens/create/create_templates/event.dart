import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> with DateParser {
  TextEditingController titleController;
  TextEditingController startDateController;
  TextEditingController endDateController;

  TextEditingController locationController;
  TextEditingController detailsController;

  File imageFile;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    locationController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    locationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Map<String, dynamic> createExpression() {
    return <String, dynamic>{
      'description': detailsController.value.text,
      'photo': imageFile,
      'title': titleController.value.text,
      'location': locationController.text,
      'startTime': DateTime.now().toUtc().toIso8601String(),
      'endTime': DateTime.now().toUtc().toIso8601String(),
      'facilitators': <String>[],
      'members': <String>[]
    };
  }

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() => imageFile = null);
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '3:2',
    ]);
    if (cropped == null) {
      setState(() => imageFile = null);
      return;
    }
    setState(() => imageFile = cropped);
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
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      setState(() {
                        imageFile = null;
                      });
                      Navigator.pop(context);
                    },
                    title: Row(
                      children: <Widget>[
                        Text(
                          'Remove photo',
                          style: Theme.of(context).textTheme.headline,
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
    return Expanded(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                        validator: Validator.validateNonEmpty,
                        controller: titleController,
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name of event',
                            hintStyle: Theme.of(context).textTheme.title),
                        cursorColor: JuntoPalette.juntoGrey,
                        cursorWidth: 2,
                        maxLines: null,
                        maxLength: 140,
                        style: Theme.of(context).textTheme.title),
                  ),
                  imageFile == null
                      ? GestureDetector(
                          onTap: () {
                            _onPickPressed();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height:
                                  (MediaQuery.of(context).size.width / 3) * 2,
                              color: Theme.of(context).dividerColor,
                              child: Icon(CustomIcons.camera,
                                  size: 38,
                                  color: Theme.of(context).primaryColorLight)),
                        )
                      : Column(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.width / 3) * 2,
                            color: Theme.of(context).dividerColor,
                            child: Image.file(imageFile, fit: BoxFit.cover),
                          ),
                          GestureDetector(
                            onTap: () {
                              _openChangePhotoModal();
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: .75),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Change photo',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                    Icon(Icons.keyboard_arrow_right,
                                        color:
                                            Theme.of(context).primaryColorLight)
                                  ],
                                )),
                          )
                        ]),
                  const SizedBox(height: 10),
                  Container(
                    child: TextField(
                      controller: startDateController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start time/date',
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
                    child: TextField(
                      controller: endDateController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'End time/date',
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
                    child: TextField(
                      controller: locationController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Location',
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
                    child: TextField(
                      controller: detailsController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Details',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
