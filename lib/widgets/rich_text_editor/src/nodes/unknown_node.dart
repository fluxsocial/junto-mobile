import 'package:flutter/material.dart';

import 'rich_text_node.dart';

class UnknownNode extends StatefulWidget {
  const UnknownNode({
    Key key,
    @required this.node,
  }) : super(key: key);

  final RichTextNode node;

  @override
  _UnknownNodeState createState() => _UnknownNodeState();
}

class _UnknownNodeState extends State<UnknownNode> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.node.focus,
      onFocusChange: (bool focus) {
        setState(() {});
      },
      child: GestureDetector(
        onTap: () {
          widget.node.focus.requestFocus();
        },
        child: Container(
          color: widget.node.focus.hasFocus ? Colors.blue : Colors.red,
          height: 24.0,
        ),
      ),
    );
  }
}
