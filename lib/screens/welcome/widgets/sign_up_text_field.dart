import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    Key key,
    @required this.valueController,
    @required this.hint,
    @required this.maxLength,
    @required this.onSubmit,
  }) : super(key: key);

  final TextEditingController valueController;
  final String hint;
  final int maxLength;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: valueController,
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        labelStyle: TextStyle(color: Colors.green),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        //disabling the native counter
        counter: Container(),
      ),
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      maxLength: maxLength,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        onSubmit();
      },
    );
  }
}
