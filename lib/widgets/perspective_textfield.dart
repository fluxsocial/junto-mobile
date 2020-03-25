import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/utils/form_validation.dart';

class PerspectiveTextField extends StatelessWidget {
  const PerspectiveTextField({
    Key key,
    @required this.name,
    @required this.controller,
    this.textInputActionType,
  }) : super(key: key);

  final String name;
  final TextEditingController controller;
  final TextInputAction textInputActionType;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        keyboardAppearance: theme.brightness,
        decoration: InputDecoration(
          counter: Container(),
          contentPadding: const EdgeInsets.all(0),
          border: InputBorder.none,
          hintText: name,
          hintStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        cursorColor: Theme.of(context).primaryColorDark,
        cursorWidth: 2,
        maxLines: 1,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
        maxLength: 80,
        textInputAction: textInputActionType,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        onFieldSubmitted: (_) {
          if (textInputActionType == TextInputAction.next) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
