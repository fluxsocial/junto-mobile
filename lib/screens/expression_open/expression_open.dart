import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_context.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/event_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression, this.userAddress, this.allowComments);

  final ExpressionResponse expression;
  final String userAddress;
  final bool allowComments;

  @override
  State<StatefulWidget> createState() => ExpressionOpenState();
}

class ExpressionOpenState extends State<ExpressionOpen> {
  //  whether the comments are visible or not
  bool commentsVisible = false;

  // whether the expression context is visible
  bool expressionContextVisible = false;

  // Create a controller for the comment text field
  TextEditingController commentController;

  /// [FocusNode] passed to Comments [TextField]
  FocusNode _focusNode;

  Future<QueryResults<Comment>> futureComments;

  bool get allowComments => widget.allowComments;

  @override
  void initState() {
    super.initState();

    commentController = TextEditingController();
    _focusNode = FocusNode();
    print(widget.expression.channels);
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
  // ignore: unused_element
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
          LongFormExpression(
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

  void toggleExpressionContext() {
    if (expressionContextVisible) {
      setState(() {
        expressionContextVisible = false;
      });
    } else if (!expressionContextVisible) {
      setState(() {
        expressionContextVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
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
                        ExpressionOpenBottom(
                            widget.expression, toggleExpressionContext),
                        if (allowComments)
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
                                          margin: EdgeInsets.only(
                                              bottom: commentsVisible ? 0 : 15),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Show replies',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(width: 5),
                                              if (!commentsVisible)
                                                Icon(Icons.keyboard_arrow_down,
                                                    size: 15,
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
                                              if (commentsVisible)
                                                Icon(Icons.keyboard_arrow_up,
                                                    size: 15,
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (commentsVisible)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount:
                                              snapshot.data.results.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CommentPreview(
                                              comment:
                                                  snapshot.data.results[index],
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
                                offset: const Offset(0.0, 50.0),
                                child: JuntoProgressIndicator(),
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
              if (allowComments)
                _BottomCommentBar(
                  postComment: _createComment,
                  commentController: commentController,
                  focusNode: _focusNode,
                ),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: expressionContextVisible ? 1.0 : 0.0,
          child: Visibility(
            visible: expressionContextVisible,
            child: ExpressionOpenContext(
                channels: widget.expression.channels,
                toggleExpressionContext: toggleExpressionContext),
          ),
        ),
      ],
    );
  }
}

class ExpressionContextChannelPreview extends StatelessWidget {
  const ExpressionContextChannelPreview(this.channel);

  final String channel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(width: .5, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 38.0,
            width: 38.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const <double>[0.2, 0.9],
                colors: <Color>[
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              CustomIcons.hash,
              color: Colors.white,
              size: 15,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(channel,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            ),
          )
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
    @required this.postComment,
  }) : super(key: key);
  final FocusNode focusNode;
  final TextEditingController commentController;
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
          horizontal: 10,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: .5,
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
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w500),
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
