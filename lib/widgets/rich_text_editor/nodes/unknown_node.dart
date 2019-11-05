import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_editor.dart';

class UnknownNode extends StatelessWidget {
  const UnknownNode({
    Key key,
    @required this.node,
  }) : super(key: key);

  final RichTextNode node;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: node.focus,
      child: GestureDetector(
        onTap: () {
          node.focus.requestFocus();
        },
        child: Container(
          color: Colors.red,
          height: 24.0,
        ),
      ),
    );
  }
}
