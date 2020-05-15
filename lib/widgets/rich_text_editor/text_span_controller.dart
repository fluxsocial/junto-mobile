import 'package:flutter/material.dart';

class TextSpanEditingController extends TextEditingController {
  TextSpanEditingController([String text]) : super(text: text);

  final _ranges = <EditingRange>[];

  void makeBold() {
    final start = value.selection.isCollapsed ?? 0;
    final end = value.selection.isCollapsed ?? value.text.length;
    _ranges.add(EditingRange(type: EditingRangeType.Bold, start: start, end: end));
    notifyListeners();
  }

  @override
  set value(TextEditingValue newValue) {
    // FIXME: adjust ranges to include new composed area
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    // FIXME: Add composing region back in to custom spans.
    // return super.buildTextSpan(style: style, withComposing: withComposing);
    // "This is <b>an</b> example <b><i>of inline</i> markup with <a href="#">links</a></b> and <a href="#">such</a>.
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: text),
      ],
    );
  }
}

enum EditingRangeType {
  Bold,
  Italic,
  Link,
}

class EditingRange {
  const EditingRange({
    @required this.type,
    @required this.start,
    @required this.end,
    this.link,
  });

  final EditingRangeType type;
  final int start;
  final int end;
  final String link;
}
