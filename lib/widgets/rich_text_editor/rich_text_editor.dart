import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/bullet_list.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/quote_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/text_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/unknown_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_controls.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/text_span_controller.dart';

import 'nodes/types.dart';
import 'rich_text_controller.dart';

const zeroWidthSpace = '\u200B';

class RichTextEditorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Focus(
              onFocusChange: (bool hasFocus) {
                print('focus other $hasFocus');
              },
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => Focus.of(context).requestFocus(),
                    child: TextField(
                      decoration: InputDecoration(
                        // fillColor: Colors.red,
                        filled: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: RichTextEditor(),
            ),
          ],
        ),
      ),
    );
  }
}

class RichTextEditor extends StatefulWidget {
  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class RichTextNode {
  RichTextNode(this.type,
      [String text = zeroWidthSpace]) // Zero Width Space (ZWSP)
      : text = TextSpanEditingController(text),
        focus = FocusNode();

  RichTextNodeType type;
  final TextSpanEditingController text;
  final FocusNode focus;

  TextSelection get selection => text.value.selection;

  bool get isEmpty =>
      text.value.text.isEmpty || text.value.text == zeroWidthSpace;

  void dispose() {
    text.dispose();
    focus.dispose();
  }
}

class _RichTextEditorState extends State<RichTextEditor>
    with TickerProviderStateMixin {
  final RichTextController controller = RichTextController();
  final ValueNotifier<bool> _showingToolbar = ValueNotifier<bool>(false);
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _focusScopeNode.addListener(_onFocusChanged);
    controller.addNode();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusScopeNode.removeListener(_onFocusChanged);
    _focusScopeNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged(RichTextNode node) {
    controller.onTextChanged(node);
  }

  void _onFocusChanged() {
    _showingToolbar.value = _focusScopeNode.hasFocus;
  }

  void _onSwipeDown(DragEndDetails details) {
    _showingToolbar.value = false;
    hideKeyboard();
  }

  void hideKeyboard() {
    _focusScopeNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      onFocusChange: (bool hasFocus) {
        print('focus editor $hasFocus');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[200], width: 1.0),
                              ),
                            ),
                            child: Builder(
                              builder: (BuildContext context) {
                                final RichTextNode node =
                                    controller.nodes[index];
                                switch (node.type) {
                                  case RichTextNodeType.Text:
                                  case RichTextNodeType.Title:
                                  case RichTextNodeType.Subtitle:
                                    return TextNode(node: node);
                                  case RichTextNodeType.Quote:
                                    return QuoteNode(node: node);
                                  case RichTextNodeType.OrderedBulletList:
                                  case RichTextNodeType.UnorderedBulletList:
                                    return BulletListNode(node: node);
                                  default:
                                    return UnknownNode(node: node);
                                }
                              },
                            ),
                          );
                        },
                        childCount: controller.nodes.length,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.addNode(inPlaceInsert: false),
                      child: SizedBox(
                        height: 96.0,
                        child: Placeholder(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => controller.addNode(inPlaceInsert: true),
              ),
            ),
          ),
          AnimatedSize(
            duration: kThemeAnimationDuration,
            alignment: Alignment.topLeft,
            vsync: this,
            child: ValueListenableBuilder<bool>(
              valueListenable: _showingToolbar,
              builder: (BuildContext context, bool showing, Widget child) {
                return SizedOverflowBox(
                  size: Size(double.infinity, showing ? kToolbarHeight : 0.0),
                  alignment: Alignment.topLeft,
                  child: child,
                );
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {},
                onVerticalDragEnd: _onSwipeDown,
                child: RichTextControls(
                  mode: controller.controlsMode,
                  onPressed: controller.onControlPressed,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: kThemeAnimationDuration,
            height: MediaQuery.of(context).viewInsets.bottom,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
        ],
      ),
    );
  }
}

class InsertLinkDialog extends StatefulWidget {
  static Future<String> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => InsertLinkDialog(),
    );
  }

  @override
  _InsertLinkDialogState createState() => _InsertLinkDialogState();
}

class _InsertLinkDialogState extends State<InsertLinkDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'http://web_address',
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('DISMISS'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: const Text('INSERT'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
