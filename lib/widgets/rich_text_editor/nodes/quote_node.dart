import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_editor.dart';

class QuoteNode extends StatelessWidget {
  const QuoteNode({
    Key key,
    @required this.node,
  }) : super(key: key);

  final RichTextNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24.0),
      padding: const EdgeInsets.only(left: 12.0),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFDDDDDD), width: 6.0)),
      ),
      child: TextField(
        controller: node.controller,
        focusNode: node.focus,
        decoration: null,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
        showCursor: true,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        keyboardAppearance: Brightness.light,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
