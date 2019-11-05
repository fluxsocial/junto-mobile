import 'package:flutter/material.dart';

class TextSpanEditingController extends TextEditingController {
  TextSpanEditingController([String text]) : super(text: text);

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    return super.buildTextSpan(style: style, withComposing: withComposing);
    /*
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: text),
      ],
    );*/
  }
}
