import 'package:flutter/services.dart';
import 'package:flutter_richtext/src/core/document.dart';
import 'package:flutter_richtext/src/core/document_layout.dart';
import 'package:flutter_richtext/src/core/document_selection.dart';
import 'package:flutter_richtext/src/infrastructure/_logging.dart';

/// Collection of generic text inspection behavior that does not belong
/// to any particular `DocumentNode` or `Component`.

final _log = Logger(scope: 'text_tools.dart');

const latinCharacters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// Returns `true` if the given `key` represents a latin character, digit, or a
/// symbol.
bool isCharacterKey(LogicalKeyboardKey key) {
  // keyLabel for a character should be: 'a', 'b',...,'A','B',...
  if (key.keyLabel.length != 1) {
    return false;
  }
  return 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890.,/;\'[]\\`~!@#\$%^&*()-=_+<>?:"{}|'
      .contains(key.keyLabel);
}

/// Returns the word of text that contains the given `docPosition`, or `null` if
/// no text exists at the given `docPosition`.
///
/// A word is defined by `TextComposable#getWordSelectionAt()`.
DocumentSelection getWordSelection({
  DocumentPosition docPosition,
  DocumentLayout docLayout,
}) {
  _log.log('getWordSelection', '_getWordSelection()');
  _log.log('getWordSelection', ' - doc position: $docPosition');

  final component = docLayout.getComponentByNodeId(docPosition.nodeId);
  if (component is! TextComposable) {
    return null;
  }

  final TextSelection wordSelection = (component as TextComposable)
      .getWordSelectionAt(docPosition.nodePosition);

  _log.log('getWordSelection', ' - word selection: $wordSelection');
  return DocumentSelection(
    base: DocumentPosition(
      nodeId: docPosition.nodeId,
      nodePosition: wordSelection.base,
    ),
    extent: DocumentPosition(
      nodeId: docPosition.nodeId,
      nodePosition: wordSelection.extent,
    ),
  );
}

/// Returns the paragraph of text that contains the given `docPosition`, or `null`
/// if there is no text at the given `docPosition`.
///
/// A paragraph is defined as all text within the given document node, bounded by
/// newlines or the beginning/end of the node's text.
DocumentSelection getParagraphSelection({
  DocumentPosition docPosition,
  DocumentLayout docLayout,
}) {
  _log.log('getParagraphSelection', '_getWordSelection()');
  _log.log('getParagraphSelection', ' - doc position: $docPosition');

  final component = docLayout.getComponentByNodeId(docPosition.nodeId);
  if (component is! TextComposable) {
    return null;
  }

  final TextSelection wordSelection = _expandPositionToParagraph(
    text: (component as TextComposable)
        .getContiguousTextAt(docPosition.nodePosition),
    textPosition: docPosition.nodePosition as TextPosition,
  );

  return DocumentSelection(
    base: DocumentPosition(
      nodeId: docPosition.nodeId,
      nodePosition: wordSelection.base,
    ),
    extent: DocumentPosition(
      nodeId: docPosition.nodeId,
      nodePosition: wordSelection.extent,
    ),
  );
}

TextSelection _expandPositionToParagraph({
  String text,
  TextPosition textPosition,
}) {
  int start = textPosition.offset;
  int end = textPosition.offset;
  while (start > 0 && text[start] != '\n') {
    start -= 1;
  }
  while (end < text.length && text[end] != '\n') {
    end += 1;
  }
  return TextSelection(
    baseOffset: start,
    extentOffset: end,
  );
}
