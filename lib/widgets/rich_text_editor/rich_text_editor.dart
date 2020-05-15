import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/bullet_list.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/quote_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/text_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/nodes/unknown_node.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/rich_text_controls.dart';
import 'package:junto_beta_mobile/widgets/rich_text_editor/text_span_controller.dart';

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
                        fillColor: Colors.red,
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

enum RichTextNodeType {
  Text,
  Title,
  Subtitle,
  //
  Quote,
  //
  UnorderedBulletList,
  OrderedBulletList,
  //
  LineBreak,
  //
  LinkUrl,
  //
  EmbeddedContent,
  //
  PhotoSmall,
  PhotoMedium,
  PhotoLarge,
}

class RichTextController {
  void _nodeDeleted(RichTextNode node) {
    //
    print('DELETE node $this');
  }
}

class RichTextNode {
  RichTextNode(this._controller, this.type, [String text = '\u200B']) // Zero Width Space (ZWSP)
      : text = TextSpanEditingController(text),
        focus = FocusNode() {
    this.text.addListener(_onTextChanged);
  }

  final RichTextController _controller;
  RichTextNodeType type;
  final TextSpanEditingController text;
  final FocusNode focus;

  TextSelection get selection => text.value.selection;

  bool get isEmpty => text.value.text.isEmpty || text.value.text == '\u200B';

  void _onTextChanged() {
    if (text.value.text.isEmpty) {
      _controller._nodeDeleted(this);
    }
  }

  void dispose() {
    text.removeListener(_onTextChanged);
    text.dispose();
    focus.dispose();
  }
}

class _RichTextEditorState extends State<RichTextEditor> with TickerProviderStateMixin {
  final ValueNotifier<bool> _showingToolbar = ValueNotifier<bool>(false);
  final ValueNotifier<RichTextControlsMode> _controlsMode =
      ValueNotifier<RichTextControlsMode>(RichTextControlsMode.InsertMode);
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final List<RichTextNode> _nodes = <RichTextNode>[];

  RichTextNode get _currentNode {
    return _nodes.firstWhere((RichTextNode node) => node.focus.hasFocus, orElse: () => null);
  }

  @override
  void initState() {
    super.initState();
    _focusScopeNode.addListener(_onFocusChanged);
    addNode(false);
  }

  @override
  void dispose() {
    for (final RichTextNode node in _nodes) {
      node.dispose();
    }
    _focusScopeNode.removeListener(_onFocusChanged);
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _onTextChanged(RichTextNode node) {
    if (_currentNode == node) {
      _controlsMode.value = (!node.selection.isCollapsed)
          ? RichTextControlsMode.SelectionMode
          : RichTextControlsMode.InsertMode;
    }
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

  void addNode(bool inPlaceInsert) {
    final RichTextNode focusedNode = _currentNode;
    RichTextNode node;
    if (inPlaceInsert && !(focusedNode?.isEmpty ?? true)) {
      node = RichTextNode(RichTextNodeType.Text);
      _nodes.insert(_nodes.indexOf(focusedNode) + 1, node);
    } else {
      node = _nodes.isNotEmpty ? _nodes[_nodes.length - 1] : null;
      if (node == null || node.controller.value.text.isNotEmpty) {
        node = RichTextNode(RichTextNodeType.Text);
        _nodes.add(node);
      } else {
        node.focus.requestFocus();
        return;
      }
    }
    setState(() {
      node.controller.addListener(() => _onTextChanged(node));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        node.focus.requestFocus();
      });
    });
  }

  void _onControlPressed(RichTextControl control) {
    final RichTextNode node = _currentNode;
    print('control $control');
    setState(() {
      switch (control) {
        case RichTextControl.TitleToggle:
          switch (node.type) {
            case RichTextNodeType.Text:
              node.type = RichTextNodeType.Title;
              break;
            case RichTextNodeType.Title:
              node.type = RichTextNodeType.Subtitle;
              break;
            case RichTextNodeType.Subtitle:
            default:
              node.type = RichTextNodeType.Text;
              break;
          }
          break;
        case RichTextControl.Quote:
          switch (node.type) {
            case RichTextNodeType.Quote:
              node.type = RichTextNodeType.Text;
              break;
            case RichTextNodeType.Text:
            default:
              node.type = RichTextNodeType.Quote;
              break;
          }
          break;
        case RichTextControl.BulletList:
          switch (node.type) {
            case RichTextNodeType.OrderedBulletList:
              node.type = RichTextNodeType.UnorderedBulletList;
              break;
            case RichTextNodeType.UnorderedBulletList:
            default:
              node.type = RichTextNodeType.OrderedBulletList;
              break;
          }
          break;
        case RichTextControl.LineBreak:
          node.type = RichTextNodeType.LineBreak;
          break;
        case RichTextControl.Bold:
          break;
        case RichTextControl.Italic:
          break;
        case RichTextControl.Link:
          InsertLinkDialog.show(context).then((String value) {
            if (value != null) {
              node.type = RichTextNodeType.LinkUrl;
            }
          });
          break;
        case RichTextControl.InsertPhoto:
          switch (node.type) {
            case RichTextNodeType.PhotoSmall:
              node.type = RichTextNodeType.PhotoMedium;
              break;
            case RichTextNodeType.PhotoMedium:
              node.type = RichTextNodeType.PhotoLarge;
              break;
            case RichTextNodeType.PhotoLarge:
            default:
              node.type = RichTextNodeType.PhotoSmall;
              break;
          }
          break;
      }
    });
    print('control $control > ${node.type}');
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
                                bottom: BorderSide(color: Colors.grey[200], width: 1.0),
                              ),
                            ),
                            child: Builder(
                              builder: (BuildContext context) {
                                final RichTextNode node = _nodes[index];
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
                        childCount: _nodes.length,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => addNode(false),
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
                onPressed: () => addNode(true),
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
                child: ValueListenableBuilder<RichTextControlsMode>(
                  valueListenable: _controlsMode,
                  builder: (BuildContext context, RichTextControlsMode mode, Widget child) {
                    return RichTextControls(
                      mode: mode,
                      onPressed: _onControlPressed,
                    );
                  },
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
