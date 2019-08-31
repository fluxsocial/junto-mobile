import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/typography/style.dart';
import 'package:junto_beta_mobile/utils/form-validation.dart';

/// Allows the user to create an event
class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  /// Sample event Expression
  //ignore: unused_field
  final Map<String, dynamic> _eventExpression = <String, dynamic>{
    'expression': <String, dynamic>{
      'expression_type': 'eventform',
      'expression_data': <String, dynamic>{
        'EventForm': <String, String>{
          'title': 'required title',
          'date': 'required date',
          'location': 'required location',
          'details': 'required details of event'
        }
      }
    },
    'tags': <String>[],
    'context': <String>['collective']
  };

  TextEditingController titleController;
  TextEditingController dateController;
  TextEditingController locationController;
  TextEditingController detailsController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    dateController = TextEditingController();
    locationController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.lotusLongformTitle,
                      maxLines: 1,
                      maxLength: 80,
                    ),
                  ),

                  // Container(
                  //   color: Color(0xfffbfbfb),
                  //   height: 200,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Center(child: Text('Add a cover photo (optional)'
                  //    ),
                  //   )
                  // ),

                  Container(
                    child: TextFormField(
                      validator: Validator.validateNonEmpty,
                      controller: dateController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Date and Time',
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.lotusLongformTitle,
                      maxLines: 1,
                      maxLength: 80,
                    ),
                  ),

                  Container(
                    child: TextFormField(
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
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.lotusLongformTitle,
                      maxLines: 1,
                      maxLength: 80,
                    ),
                  ),

                  Container(
                    constraints:
                        const BoxConstraints(minHeight: 100, maxHeight: 240),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      validator: Validator.validateNonEmpty,
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
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.lotusLongformTitle,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                  )
                ],
              ),
            ),
            // CreateActions(_eventExpression)
          ],
        ),
      ),
    );
  }
}
