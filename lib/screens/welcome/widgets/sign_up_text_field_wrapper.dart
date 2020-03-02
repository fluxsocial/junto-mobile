import 'package:flutter/material.dart';

import 'sign_up_page_title.dart';
import 'sign_up_text_field.dart';
import 'sign_up_text_field_counter.dart';

class SignUpTextFieldWrapper extends StatefulWidget {
  const SignUpTextFieldWrapper({
    Key key,
    @required this.onValueChanged,
    @required this.onSubmit,
    @required this.maxLength,
    @required this.hint,
    @required this.label,
    @required this.title,
  }) : super(key: key);

  /// Called when the user enters a value in the textfield.
  /// Value will always be the latest value of `TextController.text.value`.
  final ValueChanged<String> onValueChanged;
  final VoidCallback onSubmit;
  final int maxLength;
  final String hint;
  final String label;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return SignUpTextFieldWrapperState();
  }
}

class SignUpTextFieldWrapperState extends State<SignUpTextFieldWrapper> {
  TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    valueController = TextEditingController();
    valueController.addListener(returnDetails);
  }

  @override
  void dispose() {
    valueController.removeListener(returnDetails);
    valueController.dispose();
    super.dispose();
  }

  void returnDetails() => widget.onValueChanged(valueController.value.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SignUpPageTitle(title: widget.title),
            Container(
              child: Column(
                children: <Widget>[
                  SignUpTextField(
                    valueController: valueController,
                    onSubmit: widget.onSubmit,
                    hint: widget.hint,
                    maxLength: widget.maxLength,
                  ),
                  const SizedBox(height: 10),
                  SignUpTextFieldLabelAndCounter(
                    label: widget.label,
                    maxLength: widget.maxLength,
                    valueController: valueController,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
