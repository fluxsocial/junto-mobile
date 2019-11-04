import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/event_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  //  whether the comments are visible or not
  bool commentsVisible = false;

  // privacy layer of the comment
  String _commentPrivacy = 'public';

  // Create a controller for the comment text field
  TextEditingController commentController;

  // Boolean that signals whether the member can create a comment or not
  bool createComment = false;

  /// [FocusNode] passed to Comments [TextField]
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Builds an expression for the given type. IE: Longform or shortform
  Widget _buildExpression() {
    final String expressionType = widget.expression.type;
    if (expressionType == 'LongForm') {
      return LongformOpen(widget.expression);
    } else if (expressionType == 'ShortForm') {
      return ShortformOpen(widget.expression);
    } else if (expressionType == 'PhotoForm') {
      return PhotoOpen(widget.expression);
    } else if (expressionType == 'EventForm') {
      return EventOpen(widget.expression);
    } else {
      print(widget.expression.type);

      return const Text('no expressions!');
    }
  }

  Widget _createCommentIcon(bool createComment) {
    if (createComment == true) {
      return GestureDetector(
        onTap: () {},
        child: Icon(
          Icons.send,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      return Icon(
        Icons.send,
        size: 20,
        color: Theme.of(context).primaryColorLight,
      );
    }
  }

  // Swipe down to dismiss keyboard
  void _onDragDown(DragDownDetails details) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // Bring the focus back to the TextField
  void _focusTextField() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  // Open modal bottom sheet and refocus TextField after dismissed
  Future<void> _showPrivacyModalSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .3,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              ListTile(
                onTap: () {
                  setState(() {
                    _commentPrivacy = 'public';
                  });
                  Navigator.pop(context);
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Public',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your comment will visible to everyone who can see '
                      'this expression.',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () {
                  setState(() {
                    _commentPrivacy = 'private';
                  });
                  Navigator.pop(context);
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Private',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your comment will only be visible to the creator of '
                      'this expression.',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    _focusTextField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragDown: _onDragDown,
              child: ListView(
                children: <Widget>[
                  ExpressionOpenTop(expression: widget.expression),
                  _buildExpression(),
                  ExpressionOpenBottom(widget.expression),
                  GestureDetector(
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
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        children: <Widget>[
                          Text('show replies (9)',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12)),
                          const SizedBox(width: 5),
                          commentsVisible == false
                              ? Icon(Icons.keyboard_arrow_down,
                                  size: 14,
                                  color: Theme.of(context).primaryColor)
                              : Icon(Icons.keyboard_arrow_up,
                                  size: 14,
                                  color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                  commentsVisible
                      ? ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: <Widget>[
                            CommentPreview(
                                commentText:
                                    'Hey there! This is what a comment preview looks like.',
                                parent: widget.expression),
                            CommentPreview(
                              parent: widget.expression,
                              commentText:
                                  'All comments are hidden initially so the viewer can have complete independence of thought while viewing expressions.',
                            ),
                            CommentPreview(
                              parent: widget.expression,
                              commentText:
                                  'In Junto, comments are treated like expressions. You can resonate them or reply to a comment (nested comments). This is quite complex so we are tacklign this once the rest of the core functionality is finished.',
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border(
                top: BorderSide(
                  width: .75,
                  color: Theme.of(context).dividerColor,
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
                                height: 38.0,
                                width: 38.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: _focusNode.hasFocus
                                ? MediaQuery.of(context).size.width - 100
                                : MediaQuery.of(context).size.width - 68,
                            constraints: const BoxConstraints(maxHeight: 180),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: commentController,
                                    onChanged: (String value) {
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
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      // hintText: 'reply',
                                    ),
                                    maxLines: null,
                                    cursorColor: Theme.of(context).primaryColor,
                                    cursorWidth: 2,
                                    style: Theme.of(context).textTheme.caption,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _focusNode.hasFocus
                        ? _createCommentIcon(createComment)
                        : const SizedBox()
                  ],
                ),
                _focusNode.hasFocus
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showPrivacyModalSheet();
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _commentPrivacy,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: 14,
                                        color:
                                            Theme.of(context).primaryColorDark)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
