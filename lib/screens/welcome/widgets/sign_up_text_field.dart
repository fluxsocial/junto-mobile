import 'package:flutter/material.dart';

class SignUpTextField extends StatefulWidget {
  const SignUpTextField({
    Key key,
    @required this.valueController,
    @required this.hint,
    @required this.maxLength,
    @required this.onSubmit,
    this.textCapitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController valueController;
  final String hint;
  final int maxLength;
  final VoidCallback onSubmit;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool obscureText;

  @override
  _SignUpTextFieldState createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  bool temporarilyVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.valueController,
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        labelStyle: TextStyle(color: Colors.green),
        hintText: widget.hint,
        suffix: _visibilityIconIfObscured(),
        hintStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        //disabling the native counter
        counter: Container(),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      textInputAction: TextInputAction.next,
      keyboardType: widget.obscureText
          ? TextInputType.visiblePassword
          : widget.keyboardType,
      onSubmitted: (_) {
        widget.onSubmit();
      },
      keyboardAppearance: Theme.of(context).brightness,
      obscureText: widget.obscureText && !temporarilyVisible,
    );
  }

  /// this will be visible only when focus is on or some text is inside
  Widget _visibilityIconIfObscured() {
    return widget.obscureText
        ? IconButton(
            icon: Icon(
              temporarilyVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                temporarilyVisible = !temporarilyVisible;
              });
            },
          )
        : null;
  }
}
