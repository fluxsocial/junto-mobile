import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_richtext/flutter_richtext.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/widgets/custom_text.dart';

class TextWithHintComponent extends StatelessWidget {
  const TextWithHintComponent({
    Key key,
    @required this.documentComponentKey,
    @required this.text,
    @required this.styleBuilder,
    this.metadata = const {},
    @required this.hintText,
    this.textAlign,
    this.textSelection,
    this.hasCursor,
    this.highlightWhenEmpty,
    this.showDebugPaint,
  }) : super(key: key);

  final GlobalKey documentComponentKey;
  final AttributedText text;
  final AttributionStyleBuilder styleBuilder;
  final Map<String, dynamic> metadata;
  final String hintText;
  final TextAlign textAlign;
  final TextSelection textSelection;
  final bool hasCursor;
  final bool highlightWhenEmpty;
  final bool showDebugPaint;

  @override
  Widget build(BuildContext context) {
    final blockType = metadata['blockType'];

    final blockLevelText = text
      ..copyText(0)
      ..addAttribution(
          blockType, TextRange(start: 0, end: text.text.length - 1));

    print('Building TextWithHintComponent with key: $documentComponentKey');
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Stack(
        children: [
          Text(
            hintText,
            textAlign: textAlign,
            style: styleBuilder({blockType}).copyWith(
              color: const Color(0xFFC3C1C1),
            ),
          ),
          Positioned.fill(
            child: CustomTextComponent(
              key: documentComponentKey,
              text: blockLevelText,
              textAlign: textAlign,
              textSelection: textSelection,
              textStyleBuilder: styleBuilder,
              highlightWhenEmpty: highlightWhenEmpty,
              showDebugPaint: showDebugPaint,
            ),
          ),
        ],
      ),
    );
  }
}

Widget titleHintBuilder(ComponentContext componentContext) {
  if (componentContext.documentNode is! ParagraphNode) {
    return null;
  }

  final hasCursor = componentContext.nodeSelection != null
      ? componentContext.nodeSelection.isExtent
      : false;
  if (componentContext.document.getNodeIndex(componentContext.documentNode) !=
          0 ||
      (componentContext.documentNode as TextNode).text.text.isNotEmpty ||
      hasCursor) {
    return null;
  }

  final textSelection = componentContext.nodeSelection == null ||
          componentContext.nodeSelection.nodeSelection is! TextSelection
      ? null
      : componentContext.nodeSelection.nodeSelection as TextSelection;
  if (componentContext.nodeSelection != null &&
      componentContext.nodeSelection.nodeSelection is! TextSelection) {
    print(
        'ERROR: Building a paragraph component but the selection is not a TextSelection: ${componentContext.documentNode.id}');
  }

  final highlightWhenEmpty = componentContext.nodeSelection == null
      ? false
      : componentContext.nodeSelection.highlightWhenEmpty;

  TextAlign textAlign = TextAlign.left;
  final textAlignName =
      (componentContext.documentNode as TextNode).metadata['textAlign'];
  switch (textAlignName) {
    case 'left':
      textAlign = TextAlign.left;
      break;
    case 'center':
      textAlign = TextAlign.center;
      break;
    case 'right':
      textAlign = TextAlign.right;
      break;
    case 'justify':
      textAlign = TextAlign.justify;
      break;
  }

  return TextWithHintComponent(
    documentComponentKey: componentContext.componentKey,
    text: (componentContext.documentNode as TextNode).text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    metadata: (componentContext.documentNode as TextNode).metadata,
    hintText: 'Enter here...',
    textAlign: textAlign,
    textSelection: textSelection,
    hasCursor: hasCursor,
    highlightWhenEmpty: highlightWhenEmpty,
    showDebugPaint: false,
  );
}

Widget firstParagraphHintBuilder(ComponentContext componentContext) {
  if (componentContext.documentNode is! ParagraphNode) {
    return null;
  }

  final hasCursor = componentContext.nodeSelection != null
      ? componentContext.nodeSelection.isExtent
      : false;
  if (componentContext.document.nodes.length > 2 ||
      componentContext.document.getNodeIndex(componentContext.documentNode) !=
          1 ||
      (componentContext.documentNode as TextNode).text.text.isNotEmpty ||
      hasCursor) {
    return null;
  }

  final textSelection = componentContext.nodeSelection == null ||
          componentContext.nodeSelection.nodeSelection is! TextSelection
      ? null
      : componentContext.nodeSelection.nodeSelection as TextSelection;
  if (componentContext.nodeSelection != null &&
      componentContext.nodeSelection.nodeSelection is! TextSelection) {
    print(
        'ERROR: Building a paragraph component but the selection is not a TextSelection: ${componentContext.documentNode.id}');
  }
  final highlightWhenEmpty = componentContext.nodeSelection == null
      ? false
      : componentContext.nodeSelection.highlightWhenEmpty;

  TextAlign textAlign = TextAlign.left;
  final textAlignName =
      (componentContext.documentNode as TextNode).metadata['textAlign'];
  switch (textAlignName) {
    case 'left':
      textAlign = TextAlign.left;
      break;
    case 'center':
      textAlign = TextAlign.center;
      break;
    case 'right':
      textAlign = TextAlign.right;
      break;
    case 'justify':
      textAlign = TextAlign.justify;
      break;
  }

  print(' - this is the 1st paragraph node');
  return TextWithHintComponent(
    documentComponentKey: componentContext.componentKey,
    text: (componentContext.documentNode as TextNode).text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    metadata: (componentContext.documentNode as TextNode).metadata,
    hintText: 'Enter your content...',
    textAlign: textAlign,
    textSelection: textSelection,
    hasCursor: hasCursor,
    highlightWhenEmpty: highlightWhenEmpty,
    showDebugPaint: false,
  );
}
