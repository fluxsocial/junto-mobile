import 'package:flutter/material.dart';

import '../text_span_controller.dart';
import 'types.dart';

const zeroWidthSpace = '\u200B';

class RichTextNode {
  RichTextNode(this.type,
      [String text = zeroWidthSpace]) // Zero Width Space (ZWSP)
      : text = TextSpanEditingController(text),
        focus = FocusNode();

  RichTextNodeType type;
  final TextSpanEditingController text;
  final FocusNode focus;

  TextSelection get selection => text.value.selection;

  bool get isEmpty =>
      text.value.text.isEmpty || text.value.text == zeroWidthSpace;

  void dispose() {
    text.dispose();
    focus.dispose();
  }
}
