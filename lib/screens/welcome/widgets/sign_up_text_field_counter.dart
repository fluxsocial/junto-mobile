import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';

import 'package:provider/provider.dart';

class SignUpTextFieldLabelAndCounter extends StatelessWidget {
  const SignUpTextFieldLabelAndCounter({
    Key key,
    @required this.label,
    @required this.maxLength,
    @required this.valueController,
    this.compact = false,
  }) : super(key: key);

  final String label;
  final int maxLength;
  final TextEditingController valueController;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      // instantiate text style
      final TextStyle style = TextStyle(
        color: JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
        fontSize: compact ? 10 : 14,
        fontWeight: FontWeight.w400,
      );
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: style),
          if (maxLength != null)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: valueController,
              builder: (
                BuildContext context,
                TextEditingValue value,
                _,
              ) {
                return Text(
                  '${value.text.length}/$maxLength',
                  style: style,
                );
              },
            ),
        ],
      );
    });
  }
}
