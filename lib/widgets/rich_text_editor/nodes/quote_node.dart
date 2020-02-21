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
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.accentColor, width: 4.0),
        ),
      ),
      child: TextField(
        controller: node.controller,
        focusNode: node.focus,
        decoration: null,
        style: const TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic,
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
