import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_interactions/expression_open_interactions.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open/shortform_open.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression);

  final Expression expression;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  TextEditingController commentController;

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

  /// When the user swipes down, the keyboard is dismissed.
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
    } else {
      return const SizedBox();
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
                    ExpressionOpenInteractions(),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Color(0xffeeeeee),
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
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
                              decoration: BoxDecoration(
                                color: const Color(0xfff9f9f9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width - 135,
                              constraints: const BoxConstraints(maxHeight: 180),
                              child: TextField(
                                focusNode: _focusNode,
                                controller: commentController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // hintText: 'reply',
                                ),
                                maxLines: null,
                                cursorColor: JuntoPalette.juntoGrey,
                                cursorWidth: 2,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xff333333),
                                ),
                                textInputAction: TextInputAction.newline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: <double>[0.1, 0.9],
                            colors: <Color>[
                              JuntoPalette.juntoBlue,
                              JuntoPalette.juntoPurple
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: const Text(
                          'REPLY',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
