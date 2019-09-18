import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/components/comment_preview/comment_preview.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open/shortform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/event_open.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression);

  final Expression expression;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  //  whether the comments are visible or not
  bool commentsVisible = false;

  TextEditingController commentController;

  bool createComment = false;

  /// [FocusNode] passed to Comments [TextField]
  FocusNode _focusNode;

  /// Notifier which is used to rebuild the UI when the keyboard has focus.
  /// See [_onKeyboardFocus] for implementation details.
  final ValueNotifier<bool> _keyboardHasFocus = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onKeyboardFocus);
  }

  @override
  void dispose() {
    commentController.dispose();
    _focusNode.removeListener(_onKeyboardFocus);
    _focusNode.dispose();
    super.dispose();
  }

  /// Controls how the pointer events are handled when the keyboard has foucs.
  /// When the keyboard has focus, the ListView does not recieve pointer events.
  /// Swiping down on the expression dismisses the keyboard then allows the user
  /// to scoll as the would.
  /// `_keyboardHasFocus` is also used to to animated the padding of the page
  /// when the keyboard is called.
  void _onKeyboardFocus() {
    if (_focusNode.hasFocus) {
      _keyboardHasFocus.value = true;
    }
    if (!_focusNode.hasFocus) {
      _keyboardHasFocus.value = false;
    }
  }

  // /// When the user swipes down, the keyboard is dismissed.
  void _onDragDown(DragDownDetails details) {
    FocusScope.of(context).unfocus();
  }

  /// When the user swipes up, the textfield is focused
  /// and the system keyboard is shown.
  void _onDragStart(DragUpdateDetails details) {
    if (details.delta.direction < -1.3) {
      FocusScope.of(context).autofocus(_focusNode);
    }
  }

  /// Builds an expression for the given type. IE: Longform or shortform
  Widget _buildExpression() {
    final String expressionType = widget.expression.expression.expressionType;
    if (expressionType == 'longform') {
      return LongformOpen(widget.expression);
    } else if (expressionType == 'shortform') {
      return ShortformOpen(widget.expression);
    } else if (expressionType == 'event') {
      return EventOpen(widget.expression);
    } else {
      return const SizedBox();
    }
  }

  _createCommentIcon(bool createComment) {
    if (createComment == true) {
      return GestureDetector(
        onTap: () {},
        child: Icon(
          Icons.send,
          size: 20,
          color: JuntoPalette.juntoPrimary,
        ),
      );
    } else {
      return const Icon(
        Icons.send,
        size: 20,
        color: Color(0xff999999),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragDown: _onDragDown,
        child: ValueListenableBuilder<bool>(
          valueListenable: _keyboardHasFocus,
          builder: (BuildContext context, bool value, Widget child) {
            return IgnorePointer(
              ignoring: value,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate,
                padding: value
                    ? EdgeInsets.only(bottom: bottomInsets)
                    : EdgeInsets.zero,
                child: child,
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ExpressionOpenTop(expression: widget.expression),
                    _buildExpression(),
                    ExpressionOpenBottom(widget.expression),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffeeeeee), width: .75),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: GestureDetector(
                        onTap: () {
                          if (commentsVisible == false) {
                            setState(() {
                              commentsVisible = true;
                            });
                          } else if (commentsVisible == true) {
                            setState(() {
                              commentsVisible = false;
                            });
                          }
                        },
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Show replies (9)',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 5),
                              commentsVisible == false
                                  ? Icon(Icons.keyboard_arrow_down, size: 17)
                                  : Icon(Icons.keyboard_arrow_up, size: 17)
                            ],
                          ),
                        ),
                      ),
                    ),
                    commentsVisible
                        ? ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: <Widget>[
                              CommentPreview(
                                commentText:
                                    'love this! is this for everyone??',
                              ),
                              CommentPreview(
                                commentText:
                                    'This reminds of me of the Junto club that was started in the late 1700s by Ben Franklin.',
                              ),
                              CommentPreview(
                                commentText: 'yo',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                              CommentPreview(
                                commentText: 'hello',
                              ),
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: JuntoPalette.juntoFade,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: JuntoStyles.horizontalPadding, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/junto-mobile__eric.png',
                                      height: 36.0,
                                      width: 36.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onVerticalDragDown: _onDragDown,
                                  onVerticalDragUpdate: _onDragStart,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff9f9f9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: _focusNode.hasFocus
                                        ? MediaQuery.of(context).size.width -
                                            100
                                        : MediaQuery.of(context).size.width -
                                            66,
                                    constraints:
                                        const BoxConstraints(maxHeight: 180),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              140,
                                          child: TextField(
                                            focusNode: _focusNode,
                                            controller: commentController,
                                            onChanged: (value) {
                                              if (value == '') {
                                                setState(() {
                                                  createComment = false;
                                                });
                                              } else if (value != '') {
                                                setState(() {
                                                  createComment = true;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              // hintText: 'reply',
                                            ),
                                            maxLines: null,
                                            cursorColor: JuntoPalette.juntoGrey,
                                            cursorWidth: 2,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: JuntoPalette.juntoGrey,
                                            ),
                                            textInputAction:
                                                TextInputAction.newline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _focusNode.hasFocus
                              ? _createCommentIcon(createComment)
                              : SizedBox()
                        ],
                      ),
                      _focusNode.hasFocus
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      print('yo');
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          color: Color(0xff737373),
                                          child: Container(
                                            height: 240,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text('Public'),
                                                ),
                                                ListTile(
                                                  title: Text('Private'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'public',
                                            style: TextStyle(
                                                color: const Color(0xff333333),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Icon(Icons.keyboard_arrow_down,
                                              size: 14)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ))
                          : SizedBox()
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
