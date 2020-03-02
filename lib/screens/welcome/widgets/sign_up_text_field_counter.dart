import 'package:flutter/material.dart';

class SignUpTextFieldLabelAndCounter extends StatelessWidget {
  const SignUpTextFieldLabelAndCounter({
    Key key,
    @required this.label,
    @required this.maxLength,
    @required this.valueController,
  }) : super(key: key);

  final String label;
  final int maxLength;
  final TextEditingController valueController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: valueController,
          builder: (
            BuildContext context,
            TextEditingValue value,
            _,
          ) {
            return Text(
              '${value.text.length}/$maxLength',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ],
    );
  }
}
