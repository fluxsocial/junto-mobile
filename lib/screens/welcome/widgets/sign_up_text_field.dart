import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';

import 'package:provider/provider.dart';

/// By setting [obscureText] to `true` you'll get
/// a fancy eye icon to toggle the visibility of the obscured text
class SignUpTextField extends StatefulWidget {
  const SignUpTextField({
    Key key,
    @required this.valueController,
    @required this.hint,
    @required this.maxLength,
    @required this.onSubmit,
    @required this.textInputActionType,
    this.textCapitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.focusNode,
    this.validator,
  }) : super(key: key);

  final TextEditingController valueController;
  final String hint;
  final int maxLength;
  final VoidCallback onSubmit;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputActionType;
  final int maxLines;
  final bool obscureText;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  /// This is used to toggle visiblity of
  /// the eye icon when text is obscured
  bool _temporarilyVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return TextFormField(
        validator: widget.validator,
        controller: widget.valueController,
        cursorColor: JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none, hintText: widget.hint,
          suffix: _visibilityIconIfObscured(theme),
          hintStyle: TextStyle(
            color: JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          fillColor: JuntoPalette().juntoWhite(theme: theme),
          //disabling the native counter
          counter: Container(),
        ),
        style: TextStyle(
          color: JuntoPalette().juntoWhite(theme: theme),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputActionType,
        keyboardType: widget.obscureText
            ? TextInputType.visiblePassword
            : widget.keyboardType,
        onFieldSubmitted: (_) {
          widget.onSubmit();
        },
        keyboardAppearance: Theme.of(context).brightness,
        obscureText: widget.obscureText && !_temporarilyVisible,
      );
    });
  }

  /// The eye icon is visible only when focus is on
  /// or some text is inside the TextField
  Widget _visibilityIconIfObscured(JuntoThemesProvider theme) {
    if (widget.obscureText) {
      return IconButton(
        tooltip: 'Show/hide password',
        icon: Icon(
          _temporarilyVisible ? Icons.visibility_off : Icons.visibility,
          color: JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _temporarilyVisible = !_temporarilyVisible;
          });
        },
      );
    } else {
      return null;
    }
  }
}
