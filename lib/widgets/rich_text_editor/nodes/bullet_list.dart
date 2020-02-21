import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_editor.dart';

class BulletListNode extends StatelessWidget {
  const BulletListNode({
    Key key,
    @required this.node,
  }) : super(key: key);

  final RichTextNode node;

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.normal,
    );
    return CustomPaint(
      painter: _BulletPainter(
        node: node,
        style: DefaultTextStyle.of(context).style.merge(style),
        textDirection: Directionality.of(context),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 4.0, bottom: 4.0),
        child: TextField(
          controller: node.controller,
          focusNode: node.focus,
          decoration: null,
          style: style,
          showCursor: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          keyboardAppearance: Brightness.light,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }
}

class _BulletPainter extends CustomPainter {
  _BulletPainter({
    @required this.node,
    @required this.style,
    @required this.textDirection,
  });

  final RichTextNode node;
  final TextStyle style;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: 'M',
        style: style,
      ),
      textDirection: textDirection,
      maxLines: 1,
    );
    painter.layout(maxWidth: size.width);
    final ui.LineMetrics metrics = painter.computeLineMetrics()[0];
    double dy = metrics.descent;
    int index = 1;
    String text = '\u2022';
    while (dy < size.height - metrics.height) {
      if (node.type == RichTextNodeType.OrderedBulletList) {
        text = '$index.';
      }
      painter.text = TextSpan(text: text, style: style);
      painter.layout(maxWidth: size.width);
      painter.paint(canvas, Offset(0.0, dy));
      dy += painter.height;
      index++;
    }
  }

  @override
  bool shouldRepaint(_BulletPainter oldDelegate) {
    return oldDelegate.node != node || oldDelegate.node.type != node.type || oldDelegate.style != style;
  }
}
