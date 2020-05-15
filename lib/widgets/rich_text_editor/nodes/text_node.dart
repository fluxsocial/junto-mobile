import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_editor.dart';

import 'types.dart';

class TextNode extends StatelessWidget {
  const TextNode({
    Key key,
    @required this.node,
  }) : super(key: key);

  final RichTextNode node;

  TextStyle _getTextStyle() {
    switch (node.type) {
      case RichTextNodeType.Title:
        return const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        );
      case RichTextNodeType.Subtitle:
        return const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        );
      case RichTextNodeType.Text:
      default:
        return const TextStyle(
          fontWeight: FontWeight.normal,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: node.text,
      focusNode: node.focus,
      decoration: null,
      style: _getTextStyle(),
      showCursor: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      keyboardAppearance: Brightness.light,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
