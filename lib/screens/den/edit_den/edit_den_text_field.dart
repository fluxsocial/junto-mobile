import 'package:flutter/material.dart';

class EditDenTextField extends StatelessWidget {
  const EditDenTextField({
    this.controller,
    this.hintText,
    this.textCapitalization = TextCapitalization.words,
    this.maxLength,
  });
  final TextEditingController controller;
  final String hintText;
  final TextCapitalization textCapitalization;
  final int maxLength;

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
        buildCounter: (
          BuildContext context, {
          int currentLength,
          int maxLength,
          bool isFocused,
        }) =>
            hintText == 'Short/Long Bio'
                ? Text(
                    '$currentLength / $maxLength',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
        maxLines: null,
        maxLength: maxLength,
        style: Theme.of(context).textTheme.caption,
        textInputAction: TextInputAction.done,
        textCapitalization: textCapitalization,
      ),
    );
  }
}
