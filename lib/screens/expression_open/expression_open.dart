import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/components/comment_preview/comment_preview.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
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
    final String expressionType = widget.expression.expression.expressionType;
    if (expressionType == 'longform') {
      return LongformOpen(widget.expression);      
    } else if (expressionType == 'shortform') {
      return ShortformOpen(widget.expression);
    } else if (expressionType == 'photo') {
      return PhotoOpen(widget.expression);
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

  // Swipe down to dismiss keyboard
  _onDragDown(DragDownDetails details) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  // Bring the focus back to the TextField
  _focusTextField() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  // Open modal bottom sheet and refocus TextField after dismissed
  _showPrivacyModalSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: 240,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              ListTile(
                onTap: () {
                  setState(() {
                    _commentPrivacy = 'public';
                  });
                  Navigator.pop(context);
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Public',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        'Your comment will visible to everyone who can see this expression.')
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
                  children: <Widget>[
                    Text(
                      'Private',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        'Your comment will only be visible to the creator of this expression.')
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
    final double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(),
      ),
      backgroundColor: Colors.white,
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
                                  'Hey there! This is what a comment preview looks like.',
                            ),
                            CommentPreview(
                              commentText:
                                  'All comments are hidden initially so the viewer can have complete independence of thought while viewing expressions.',
                            ),
                            CommentPreview(
                              commentText:
                                  'In Junto, comments are treated like expressions. You can resonate them or reply to a comment (nested comments). This is quite complex so we are tacklign this once the rest of the core functionality is finished.',
                            ),
                            CommentPreview(
                              commentText:
                                  "And yes, I know what you're thinking. 'Comments??' We need a new semantic!",
                            ),
                            CommentPreview(
                              commentText:
                                  "Let's leave that to Fri to discuss :)",
                            ),
                            CommentPreview(
                              commentText: 'Much',
                            ),
                            CommentPreview(
                              commentText: 'love <3',
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
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
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xfff9f9f9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: _focusNode.hasFocus
                                ? MediaQuery.of(context).size.width - 100
                                : MediaQuery.of(context).size.width - 66,
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
                                _showPrivacyModalSheet();
                              },
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _commentPrivacy,
                                      style: TextStyle(
                                          color: const Color(0xff333333),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(Icons.keyboard_arrow_down, size: 14)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
