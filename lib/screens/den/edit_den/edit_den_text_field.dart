import 'package:flutter/material.dart';

class EditDenTextField extends StatelessWidget {
  const EditDenTextField({
    this.controller,
    this.hintText,
    this.textCapitalization = TextCapitalization.words,
  });
  final TextEditingController controller;
  final String hintText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        textInputAction: TextInputAction.done,
        textCapitalization: textCapitalization,
      ),
    );
  }
}
