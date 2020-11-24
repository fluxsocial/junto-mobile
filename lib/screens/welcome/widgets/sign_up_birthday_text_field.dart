import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class SignUpBirthdayTextField extends StatelessWidget {
  const SignUpBirthdayTextField({
    this.hintText,
    this.maxLength,
  });

  final String hintText;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, child) {
        return TextField(
          keyboardType: TextInputType.number,
          maxLength: 2,
          maxLengthEnforced: true,
          buildCounter: (
            BuildContext context, {
            int currentLength,
            int maxLength,
            bool isFocused,
          }) =>
              null,
          style: TextStyle(
            color: JuntoPalette().juntoWhite(theme: theme),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            fillColor: JuntoPalette().juntoWhite(theme: theme),
          ),
        );
      },
    );
  }
}
