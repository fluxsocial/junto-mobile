import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/image_widgets.dart';
import 'package:junto_beta_mobile/widgets/time_pickers.dart';

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  CreateEventState createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> with DateParser {
  TextEditingController titleController;

  TextEditingController locationController;
  TextEditingController detailsController;

  ValueNotifier<File> imageFile = ValueNotifier<File>(null);
  ValueNotifier<DateTime> startTime = ValueNotifier<DateTime>(null);
  ValueNotifier<DateTime> endTime = ValueNotifier<DateTime>(null);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    locationController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
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
      'start_time': startTime.value.toUtc().toIso8601String(),
      'end_time': endTime.value.toUtc().toIso8601String(),
      'facilitators': <String>[],
      'members': <String>[]
    };
  }

  void _openChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff737373),
      builder: (BuildContext context) {
        return ChangeImage(
          imageFile: imageFile,
          pickImage: _onPickPressed,
        );
      },
    );
  }

  Future<void> _onPickPressed() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      imageFile.value = null;
      return;
    }
    final File cropped =
        await ImageCroppingDialog.show(context, image, aspectRatios: <String>[
      '3:2',
    ]);
    if (cropped == null) {
      imageFile.value = null;
      return;
    }
    imageFile.value = cropped;
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
                        hintStyle: Theme.of(context).textTheme.headline6,
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      maxLength: 140,
                      textInputAction: TextInputAction.done,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ValueListenableBuilder<File>(
                    valueListenable: imageFile,
                    builder: (BuildContext context, File value, Widget child) {
                      if (value == null) {
                        return EmptyImageWidget(
                          imageFile: imageFile,
                          pickImage: _onPickPressed,
                        );
                      }
                      return Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.width / 3) * 2,
                            color: Theme.of(context).dividerColor,
                            child: Image.file(
                              value,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: _openChangePhotoModal,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Change photo',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context).primaryColorLight,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: Listenable.merge(<ValueNotifier<DateTime>>[
                      endTime,
                      startTime,
                    ]),
                    builder: (BuildContext context, _) {
                      return CreateDateSelector(
                        endTime: endTime,
                        startTime: startTime,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      controller: locationController,
                      validator: Validator.validateNonEmpty,
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
                    child: TextFormField(
                      controller: detailsController,
                      validator: Validator.validateNonEmpty,
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
