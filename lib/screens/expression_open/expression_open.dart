import 'package:embedly_preview/embedly_preview.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
import 'package:junto_beta_mobile/screens/expression_open/expressions/link_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/widgets/comments/comments_list.dart';
import 'package:junto_beta_mobile/widgets/comments/bottom_comment_bar.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';
import 'package:provider/provider.dart';

import 'expressions/audio_open.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(
    this.deleteExpression,
    this.expression,
  );

  final ExpressionResponse expression;

  final ValueChanged<ExpressionResponse> deleteExpression;

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

  // scroll controller for expression open list view
  ScrollController _scrollController;

  /// [FocusNode] passed to Comments [TextField]
  FocusNode _focusNode;

  Future<QueryResults<Comment>> futureComments;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _scrollController = ScrollController();
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
    } else if (expressionType == 'AudioForm') {
      return AudioOpen(widget.expression);
    } else if (expressionType == 'LinkForm') {
      return LinkOpen(widget.expression);
    } else {
      return const SizedBox();
    }
  }

  // Swipe down to dismiss keyboard
  void _onDragDown(DragDownDetails details) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // open comments
  void _openComments() {
    setState(() {
      commentsVisible = true;
    });
  }

  // close comments
  void _closeComments() {
    setState(() {
      commentsVisible = false;
    });
  }

  // toggle comments visibility
  void _showComments() {
    if (commentsVisible == false) {
      _openComments();
    } else if (commentsVisible == true) {
      _closeComments();
    }
  }

  // scroll to bottom of list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  // refresh comments
  Future<void> _refreshComments() async {
    setState(
      () {
        futureComments = Provider.of<ExpressionRepo>(context, listen: false)
            .getExpressionsComments(widget.expression.address);
      },
    );
  }

  // toggle expression context view
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
    return FeatureDiscovery(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: ExpressionOpenAppbar(expression: widget.expression),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragDown: _onDragDown,
                    child: CustomRefresh(
                      refresh: _refreshComments,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        children: <Widget>[
                          // Expression Top
                          ExpressionOpenTop(
                            expression: widget.expression,
                            deleteExpression: widget.deleteExpression,
                          ),
                          // Expression Body
                          _buildExpression(),
                          // Expression Open Bottom
                          ExpressionOpenBottom(
                            widget.expression,
                            toggleExpressionContext,
                          ),
                          // List of comments
                          CommentsList(
                            commentsVisible: commentsVisible,
                            expression: widget.expression,
                            futureComments: futureComments,
                            showComments: _showComments,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Reply Widget
                BottomCommentBar(
                  expressionAddress: widget.expression.address,
                  openComments: _openComments,
                  refreshComments: _refreshComments,
                  scrollToBottom: _scrollToBottom,
                  focusNode: _focusNode,
                ),
              ],
            ),
          ),
          // Expression Context
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: expressionContextVisible ? 1.0 : 0.0,
            child: Visibility(
              visible: expressionContextVisible,
              child: ExpressionOpenContext(
                channels: widget.expression.channels,
                toggleExpressionContext: toggleExpressionContext,
              ),
            ),
          ),
        ],
      ),
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
              CustomIcons.newhashtag,
              color: Colors.white,
              size: 24,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  channel,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
