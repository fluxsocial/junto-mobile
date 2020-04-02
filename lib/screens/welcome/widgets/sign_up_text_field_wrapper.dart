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
    @required this.textInputActionType,
    @required this.textCapitalization,
  }) : super(key: key);

  /// Called when the user enters a value in the textfield.
  /// Value will always be the latest value of `TextController.text.value`.
  final ValueChanged<String> onValueChanged;
  final VoidCallback onSubmit;
  final int maxLength;
  final String hint;
  final String label;
  final String title;
  final TextInputAction textInputActionType;
  final TextCapitalization textCapitalization;

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
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SignUpPageTitle(title: widget.title),
            SizedBox(height: size.height * 0.24),
            Column(
              children: <Widget>[
                SignUpTextField(
                  valueController: valueController,
                  onSubmit: widget.onSubmit,
                  hint: widget.hint,
                  maxLength: widget.maxLength,
                  textInputActionType: widget.textInputActionType,
                  textCapitalization:
                      widget.textCapitalization ?? TextCapitalization.none,
                ),
                SignUpTextFieldLabelAndCounter(
                  label: widget.label,
                  maxLength: widget.maxLength,
                  valueController: valueController,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
