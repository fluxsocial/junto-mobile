import 'package:flutter/material.dart';

import '../text_span_controller.dart';
import 'types.dart';

const zeroWidthSpace = '\u200B';

class RichTextNode {
  RichTextNode(this.type,
      [String text = zeroWidthSpace]) // Zero Width Space (ZWSP)
      : controller = TextSpanEditingController(text),
        focus = FocusNode();

  RichTextNodeType type;
  final TextSpanEditingController controller;
  final FocusNode focus;

  TextSelection get selection => controller.value.selection;

  bool get isEmpty =>
      controller.value.text.isEmpty || controller.value.text == zeroWidthSpace;

  bool get isReallyEmpty => controller.value.text.isEmpty;

  void dispose() {
    controller.dispose();
    focus.dispose();
  }
}
