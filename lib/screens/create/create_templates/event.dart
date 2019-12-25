import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';
import 'package:junto_beta_mobile/utils/utils.dart';

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

  @override
  void initState() {
    super.initState();
    print(DateTime.now());
    titleController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    locationController = TextEditingController();
    detailsController = TextEditingController();
  }

  CentralizedEventFormExpression createExpression() {
    return CentralizedEventFormExpression(
        description: 'event description',
        photo: 'photo',
        title: 'event title',
        location: 'NYC',
        startTime: DateTime.now().toIso8601String(),
        endTime: DateTime.now().toIso8601String());
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
                        style: Theme.of(context).textTheme.display1),
                  ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
