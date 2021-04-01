import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SelectableText;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_richtext/src/core/document_layout.dart';
import 'package:flutter_richtext/src/infrastructure/attributed_text.dart';
import 'package:flutter_richtext/src/infrastructure/selectable_text.dart';

import 'text_tools.dart';

class CustomTextComponent extends StatefulWidget {
  const CustomTextComponent({
    Key key,
    this.text,
    this.textAlign,
    this.textStyleBuilder,
    this.metadata = const {},
    this.textSelection,
    this.selectionColor = Colors.lightBlueAccent,
    this.showCaret = false,
    this.caretColor = Colors.black,
    this.highlightWhenEmpty = false,
    this.showDebugPaint = false,
    this.pattern,
  }) : super(key: key);

  final AttributedText text;
  final TextAlign textAlign;
  final AttributionStyleBuilder textStyleBuilder;
  final Map<String, dynamic> metadata;
  final TextSelection textSelection;
  final Color selectionColor;
  final bool showCaret;
  final Color caretColor;
  final bool highlightWhenEmpty;
  final bool showDebugPaint;
  final String pattern;

  @override
  _CustomTextComponentState createState() => _CustomTextComponentState();
}

class _CustomTextComponentState extends State<CustomTextComponent>
    with DocumentComponent
    implements TextComposable {
  final _selectableTextKey = GlobalKey<SelectableTextState>();

  @override
  TextPosition getPositionAtOffset(Offset localOffset) {
    final textLayout = _selectableTextKey.currentState;
    return textLayout.getPositionAtOffset(localOffset);
  }

  @override
  Offset getOffsetForPosition(dynamic nodePosition) {
    if (nodePosition is! TextPosition) {
      throw Exception(
          'Expected nodePosition of type TextPosition but received: $nodePosition');
    }
    return _selectableTextKey.currentState.getOffsetForPosition(nodePosition);
  }

  @override
  Rect getRectForPosition(dynamic nodePosition) {
    if (nodePosition is! TextPosition) {
      throw Exception(
          'Expected nodePosition of type TextPosition but received: $nodePosition');
    }

    // TODO: factor in line height for position rect
    final offset = getOffsetForPosition(nodePosition);
    return Rect.fromLTWH(offset.dx, offset.dy, 0, 0);
  }

  @override
  TextPosition getBeginningPosition() {
    return TextPosition(offset: 0);
  }

  @override
  TextPosition getBeginningPositionNearX(double x) {
    return _selectableTextKey.currentState.getPositionInFirstLineAtX(x);
  }

  @override
  TextPosition movePositionLeft(dynamic textPosition,
      [Map<String, dynamic> movementModifiers]) {
    if (textPosition is! TextPosition) {
      // We don't know how to interpret a non-text position.
      return null;
    }

    if (textPosition.offset > widget.text.text.length) {
      // This text position does not represent a position within our text.
      return null;
    }

    if (textPosition.offset == 0) {
      // Can't move any further left.
      return null;
    }

    if (movementModifiers['movement_unit'] == 'line') {
      return getPositionAtStartOfLine(
        TextPosition(offset: textPosition.offset),
      );
    }

    if (movementModifiers['movement_unit'] == 'word') {
      final text = getContiguousTextAt(textPosition);

      int newOffset = textPosition.offset;
      newOffset -= 1; // we always want to jump at least 1 character.
      while (newOffset > 0 && latinCharacters.contains(text[newOffset])) {
        newOffset -= 1;
      }
      return TextPosition(offset: newOffset);
    }

    return TextPosition(offset: textPosition.offset - 1);
  }

  @override
  TextPosition movePositionRight(dynamic textPosition,
      [Map<String, dynamic> movementModifiers]) {
    if (textPosition is! TextPosition) {
      // We don't know how to interpret a non-text position.
      return null;
    }

    if (textPosition.offset >= widget.text.text.length) {
      // Can't move further right.
      return null;
    }

    if (movementModifiers['movement_unit'] == 'line') {
      final endOfLine = getPositionAtEndOfLine(
        TextPosition(offset: textPosition.offset),
      );
      if (endOfLine == null) {
        return null;
      }

      final TextPosition endPosition = getEndPosition();
      final text = getContiguousTextAt(endOfLine);

      // Note: we compare offset values because we don't care if the affinitys are equal
      final isAutoWrapLine = endOfLine.offset != endPosition.offset &&
          (text[endOfLine.offset] != '\n');

      // Note: For lines that auto-wrap, moving the cursor to `offset` causes the
      //       cursor to jump to the next line because the cursor is placed after
      //       the final selected character. We don't want this, so in this case
      //       we `-1`.
      //
      //       However, if the line that is selected ends with an explicit `\n`,
      //       or if the line is the terminal line for the paragraph then we don't
      //       want to `-1` because that would leave a dangling character after the
      //       selection.
      // TODO: this is the concept of text affinity. Implement support for affinity.
      // TODO: with affinity, ensure it works as expected for right-aligned text
      // TODO: this logic fails for justified text - find a solution for that (#55)
      return isAutoWrapLine
          ? TextPosition(offset: endOfLine.offset - 1)
          : endOfLine;
    }

    if (movementModifiers['movement_unit'] == 'word') {
      final text = getContiguousTextAt(textPosition);

      int newOffset = textPosition.offset;
      newOffset += 1; // we always want to jump at least 1 character.
      while (newOffset < text.length &&
          latinCharacters.contains(text[newOffset])) {
        newOffset += 1;
      }
      return TextPosition(offset: newOffset);
    }

    return TextPosition(offset: textPosition.offset + 1);
  }

  @override
  TextPosition movePositionUp(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      // We don't know how to interpret a non-text position.
      return null;
    }

    if (textPosition.offset < 0 ||
        textPosition.offset > widget.text.text.length) {
      // This text position does not represent a position within our text.
      return null;
    }

    return getPositionOneLineUp(textPosition);
  }

  @override
  TextPosition movePositionDown(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      // We don't know how to interpret a non-text position.
      return null;
    }

    if (textPosition.offset < 0 ||
        textPosition.offset > widget.text.text.length) {
      // This text position does not represent a position within our text.
      return null;
    }

    return getPositionOneLineDown(textPosition);
  }

  @override
  TextPosition getEndPosition() {
    return TextPosition(offset: widget.text.text.length);
  }

  @override
  TextPosition getEndPositionNearX(double x) {
    return _selectableTextKey.currentState.getPositionInLastLineAtX(x);
  }

  @override
  TextSelection getSelectionInRange(
      Offset localBaseOffset, Offset localExtentOffset) {
    return _selectableTextKey.currentState
        .getSelectionInRect(localBaseOffset, localExtentOffset);
  }

  @override
  TextSelection getCollapsedSelectionAt(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      return null;
    }

    return TextSelection.fromPosition(textPosition);
  }

  @override
  TextSelection getSelectionBetween({
    dynamic basePosition,
    dynamic extentPosition,
  }) {
    if (basePosition is! TextPosition) {
      throw Exception(
          'Expected a basePosition of type TextPosition but received: $basePosition');
    }
    if (extentPosition is! TextPosition) {
      throw Exception(
          'Expected a extentPosition of type TextPosition but received: $extentPosition');
    }

    return TextSelection(
      baseOffset: basePosition.offset,
      extentOffset: extentPosition.offset,
    );
  }

  @override
  TextSelection getSelectionOfEverything() {
    return TextSelection(
      baseOffset: 0,
      extentOffset: widget.text.text.length,
    );
  }

  @override
  MouseCursor getDesiredCursorAtOffset(Offset localOffset) {
    return _selectableTextKey.currentState.isTextAtOffset(localOffset)
        ? SystemMouseCursors.text
        : null;
  }

  @override
  TextSelection getWordSelectionAt(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      throw Exception(
          'Expected a node position of type TextPosition but received: $textPosition');
    }

    return _selectableTextKey.currentState.getWordSelectionAt(textPosition);
  }

  @override
  String getContiguousTextAt(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      throw Exception(
          'Expected a node position of type TextPosition but received: $textPosition');
    }

    // This component only displays a single contiguous span of text.
    // Therefore, all of our text is contiguous regardless of position.
    // TODO: This assumption isn't true in the case that multiline text
    //       is displayed within 1 node, such as when the user presses
    //       shift+enter. Change implementation to find actual contiguous
    //       text. (#54)
    return widget.text.text;
  }

  TextPosition getPositionOneLineUp(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      return null;
    }

    return _selectableTextKey.currentState.getPositionOneLineUp(
      currentPosition: textPosition,
    );
  }

  TextPosition getPositionOneLineDown(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      return null;
    }

    return _selectableTextKey.currentState.getPositionOneLineDown(
      currentPosition: textPosition,
    );
  }

  @override
  TextPosition getPositionAtEndOfLine(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      return null;
    }
    return _selectableTextKey.currentState
        .getPositionAtEndOfLine(currentPosition: textPosition);
  }

  @override
  TextPosition getPositionAtStartOfLine(dynamic textPosition) {
    if (textPosition is! TextPosition) {
      return null;
    }
    return _selectableTextKey.currentState
        .getPositionAtStartOfLine(currentPosition: textPosition);
  }

  @override
  Widget build(BuildContext context) {
    final blockType = widget.metadata['blockType'];

    // Surround the text with block level attributions.
    final blockText = widget.text.copyText(0)
      ..addAttribution(
        blockType,
        TextRange(start: 0, end: widget.text.text.length - 1),
      );
    final richText =
        computeTextSpan(widget.textStyleBuilder, blockText, widget.pattern);

    return SelectableText(
      key: _selectableTextKey,
      textSpan: richText, //TextSpan(children: children),
      textAlign: widget.textAlign ?? TextAlign.left,
      textSelection:
          widget.textSelection ?? TextSelection.collapsed(offset: -1),
      textSelectionDecoration:
          TextSelectionDecoration(selectionColor: widget.selectionColor),
      showCaret: widget.showCaret,
      textCaretFactory: TextCaretFactory(color: widget.caretColor),
      highlightWhenEmpty: widget.highlightWhenEmpty,
    );
  }
}

/// Returns a Flutter `TextSpan` that is styled based on the
/// attributions within this `AttributedText`.
///
/// The given `styleBuilder` interprets the meaning of every
/// attribution and constructs `TextStyle`s accordingly.
TextSpan computeTextSpan(AttributionStyleBuilder styleBuilder,
    AttributedText attributedText, String pattern) {
  final text = attributedText.text;
  final spans = attributedText.spans;
  if (text.isEmpty) {
    // There is no text and therefore no attributions.
    return TextSpan(text: '', style: styleBuilder({}));
  }

  final collapsedSpans = spans.collapseSpans(contentLength: text.length);
  print('${collapsedSpans.length}');
  final textSpans = collapsedSpans.map((attributedSpan) {
    final _text = text.substring(attributedSpan.start, attributedSpan.end + 1);

    var children = <InlineSpan>[];

    _text.splitMapJoin(
      RegExp('${pattern}'),
      onMatch: (Match match) {
        children.add(
          TextSpan(
            text: match[0],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text));
        return '';
      },
    );

    if (children.isEmpty) {
      return TextSpan(
        text: text.substring(attributedSpan.start, attributedSpan.end + 1),
        style: styleBuilder(attributedSpan.attributions),
      );
    } else {
      return TextSpan(
          children: children, style: styleBuilder(attributedSpan.attributions));
    }
  }).toList();

  return textSpans.length == 1
      ? textSpans.first
      : TextSpan(
          children: textSpans,
          style: styleBuilder({}),
        );
}

/// Creates `TextStyles` for the standard `Editor`.
TextStyle defaultRichtextStyleBuilder(Set<dynamic> attributions) {
  TextStyle newStyle = TextStyle(
    color: Colors.black,
    fontSize: 13,
    height: 1.4,
  );

  for (final attribution in attributions) {
    if (attribution is! String) {
      continue;
    }

    switch (attribution) {
      case 'header1':
        newStyle = newStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.0,
        );
        break;
      case 'header2':
        newStyle = newStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF888888),
          height: 1.0,
        );
        break;
      case 'blockquote':
        newStyle = newStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.4,
          color: Colors.grey,
        );
        break;
      case 'bold':
        newStyle = newStyle.copyWith(
          fontWeight: FontWeight.bold,
        );
        break;
      case 'italics':
        newStyle = newStyle.copyWith(
          fontStyle: FontStyle.italic,
        );
        break;
      case 'strikethrough':
        newStyle = newStyle.copyWith(
          decoration: TextDecoration.lineThrough,
        );
        break;
      case 'underline':
        newStyle = newStyle.copyWith(
          decoration: TextDecoration.underline,
        );
        break;
    }
  }
  return newStyle;
}
