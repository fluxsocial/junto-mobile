import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/event_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression, this.userAddress);

  final CentralizedExpressionResponse expression;
  final String userAddress;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenState();
  }
}

class ExpressionOpenState extends State<ExpressionOpen> {
  final List<String> comments = <String>[
    'Hey there! This is what a comment preview looks like.',
    'All comments are hidden initially so the viewer can have complete independence of thought while viewing expressions.',
    'In Junto, comments are treated like expressions. You can resonate them or reply to a comment (nested comments). This is quite complex so we are tacklign this once the rest of the core functionality is finished.',
    "And yes, I know what you're thinking. 'Comments??' We need a new semantic!",
  ];

  //  whether the comments are visible or not
  bool commentsVisible = false;

  // Create a controller for the comment text field
  TextEditingController commentController;

  /// [FocusNode] passed to Comments [TextField]
  FocusNode _focusNode;

  Future<QueryResults<Comment>> futureComments;

  @override
  void initState() {
    super.initState();

    commentController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    futureComments = Provider.of<ExpressionRepo>(context, listen: false)
        .getExpressionsComments(widget.expression.address);
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
      return const Text('no expressions!');
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

  void _showComments() {
    if (commentsVisible == false) {
      setState(() {
        commentsVisible = true;
      });
    } else if (commentsVisible == true) {
      setState(() {
        commentsVisible = false;
      });
    }
  }

  Future<void> _createComment() async {
    if (commentController.value.text != '') {
      JuntoLoader.showLoader(context);
      try {
        await Provider.of<ExpressionRepo>(context, listen: false)
            .postCommentExpression(
          widget.expression.address,
          'LongForm',
          CentralizedLongFormExpression(
            title: 'Expression Comment',
            body: commentController.value.text,
          ).toMap(),
        );
        commentController.clear();
        JuntoLoader.hide();
        JuntoDialog.showJuntoDialog(
          context,
          'Comment Created',
          <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      } catch (error) {
        debugPrint('Error posting comment $error');
        JuntoLoader.hide();

        JuntoDialog.showJuntoDialog(
          context,
          'Error posting comment',
          <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      }
    } else {
      return;
    }
  }

  Future<void> _refreshComments() async {
    setState(
      () {
        futureComments = Provider.of<ExpressionRepo>(context, listen: false)
            .getExpressionsComments(widget.expression.address);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(expression: widget.expression),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragDown: _onDragDown,
              child: RefreshIndicator(
                onRefresh: _refreshComments,
                child: ListView(
                  children: <Widget>[
                    ExpressionOpenTop(
                        expression: widget.expression,
                        userAddress: widget.userAddress),
                    _buildExpression(),
                    ExpressionOpenBottom(widget.expression, _focusTextField),
                    FutureBuilder<QueryResults<Comment>>(
                      future: futureComments,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QueryResults<Comment>> snapshot,
                      ) {
                        if (snapshot.hasError) {
                          return Container(
                            child: const Text('Error occured'),
                          );
                        }

                        if (snapshot.hasData) {
                          if (snapshot.data.results.isNotEmpty) {
                            return Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: _showComments,
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Show replies',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 5),
                                        if (commentsVisible == false)
                                          Icon(Icons.keyboard_arrow_down,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        if (commentsVisible != false)
                                          Icon(Icons.keyboard_arrow_up,
                                              size: 17,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                      ],
                                    ),
                                  ),
                                ),
                                if (commentsVisible)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: snapshot.data.results.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CommentPreview(
                                        comment: snapshot.data.results[index],
                                        parent: widget.expression,
                                        userAddress: widget.userAddress,
                                      );
                                    },
                                  ),
                              ],
                            );
                          } else
                            return const SizedBox();
                        }
                        return Transform.translate(
                          offset: const Offset(0.0, -50.0),
                          child: JuntoProgressIndicator(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          _BottomCommentBar(
            postComment: _createComment,
            commentController: commentController,
            focusNode: _focusNode,
            onGifSelected: (_) {},
          ),
        ],
      ),
    );
  }
}

class _BottomCommentBar extends StatefulWidget {
  const _BottomCommentBar({
    Key key,
    @required this.focusNode,
    @required this.commentController,
    @required this.onGifSelected,
    @required this.postComment,
  }) : super(key: key);
  final FocusNode focusNode;
  final TextEditingController commentController;
  final ValueChanged<String> onGifSelected;
  final VoidCallback postComment;

  @override
  _BottomCommentBarState createState() => _BottomCommentBarState();
}

enum MessageType { regular, gif }

class _BottomCommentBarState extends State<_BottomCommentBar> {
  String selectedUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: JuntoStyles.horizontalPadding,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            top: BorderSide(
              width: .75,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
                constraints: const BoxConstraints(maxHeight: 180),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        focusNode: widget.focusNode,
                        controller: widget.commentController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write a reply...',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor),
                        ),
                        maxLines: null,
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 2,
                        style: Theme.of(context).textTheme.caption,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: widget.postComment,
              child: Icon(
                Icons.send,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
