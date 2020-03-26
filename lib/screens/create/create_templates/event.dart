import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/utils/form_validation.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:junto_beta_mobile/widgets/image_widgets.dart';
import 'package:junto_beta_mobile/widgets/time_pickers.dart';

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.expressionContext, this.address})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      'description': detailsController.value.text.trim(),
      'photo': imageFile.value,
      'title': titleController.value.text.trim(),
      'location': locationController.text.trim(),
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

  void _onNext() {
    if (_formKey.currentState.validate() == true) {
      final Map<String, dynamic> expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return CreateActions(
              expressionType: ExpressionType.event,
              address: widget.address,
              expressionContext: widget.expressionContext,
              expression: expression,
            );
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Please fill in the required fields.',
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      expressionType: ExpressionType.event,
      onNext: _onNext,
      child: Expanded(
        child: Form(
          key: _formKey,
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
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 2,
                        maxLines: null,
                        maxLength: 140,
                        textInputAction: TextInputAction.done,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    ValueListenableBuilder<File>(
                      valueListenable: imageFile,
                      builder:
                          (BuildContext context, File value, Widget child) {
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
                              height:
                                  (MediaQuery.of(context).size.width / 3) * 2,
                              color: Theme.of(context).dividerColor,
                              child: Image.file(
                                value,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: _openChangePhotoModal,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
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
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color:
                                          Theme.of(context).primaryColorLight,
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
      ),
    );
  }
}
