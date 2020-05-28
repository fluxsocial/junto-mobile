import 'package:flutter/material.dart';

class PerspectiveTextField extends StatelessWidget {
  const PerspectiveTextField({
    Key key,
    @required this.name,
    @required this.controller,
    this.textInputActionType,
    this.validator,
    this.maxLength,
  }) : super(key: key);

  final String name;
  final TextEditingController controller;
  final TextInputAction textInputActionType;
  final FormFieldValidator<String> validator;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
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
        controller: controller,
        keyboardAppearance: theme.brightness,
        validator: validator,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.redAccent),
          contentPadding: const EdgeInsets.all(0),
          counter: Container(),
          border: InputBorder.none,
          hintText: name,
          hintStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
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
        textInputAction: textInputActionType,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        maxLength: maxLength,
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
