import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/comments/bottom_comment_bar.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/comments/comments_list.dart';
import 'package:provider/provider.dart';

import 'comment_open_bottom.dart';
import 'comment_open_parent/comment_open_parent.dart';
import 'comment_open_top.dart';

import 'types/audio.dart';
import 'types/dynamic.dart';
import 'types/photo.dart';
import 'types/shortform.dart';

class CommentOpen extends StatefulWidget {
  const CommentOpen({
    @required this.comment,
    @required this.userAddress,
    @required this.parent,
  });

  final Comment comment;
  final String userAddress;
  final dynamic parent;

  @override
  State<StatefulWidget> createState() {
    return CommentOpenState();
  }
}

class CommentOpenState extends State<CommentOpen> {
  Future<QueryResults<Comment>> futureComments;
  //  whether the comments are visible or not
  bool commentsVisible = false;

  // scroll controller for expression open list view
  ScrollController _scrollController;

  // Focus node for comment text fioeld
  FocusNode _focusNode;

  // make comments visibility
  void _openComments() {
    setState(() {
      commentsVisible = true;
    });
  }

  // make comments invisible
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

  Future<void> _refreshComments() async {
    setState(
      () {
        futureComments = Provider.of<ExpressionRepo>(context, listen: false)
            .getExpressionsComments(widget.comment.address);
      },
    );
  }

  // scroll to bottom of list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  /// Builds an expression for the given type. IE: Longform or shortform
  Widget _buildExpression() {
    final String expressionType = widget.comment.type;
    if (expressionType == 'LongForm') {
      return DynamicOpen(widget.comment);
    } else if (expressionType == 'ShortForm') {
      return ShortformOpen(widget.comment);
    } else if (expressionType == 'PhotoForm') {
      return PhotoOpen(widget.comment);
    } else if (expressionType == 'AudioForm') {
      return AudioOpen(widget.comment);
    } else {
      return const SizedBox();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    futureComments = Provider.of<ExpressionRepo>(context, listen: false)
        .getExpressionsComments(widget.comment.address);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: CommentOpenAppbar(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              children: <Widget>[
                // Comment Parent
                CommentOpenParent(
                  comment: widget.comment,
                  parent: widget.parent,
                ),
                // Comment Open Top
                CommentOpenTop(
                  comment: widget.comment,
                  userAddress: widget.userAddress,
                ),
                // Comment Body
                _buildExpression(),
                // Comment Bottom
                CommentOpenBottom(
                  comment: widget.comment,
                ),
                // List of comments
                CommentsList(
                  commentsVisible: commentsVisible,
                  expression: widget.comment,
                  userAddress: widget.userAddress,
                  futureComments: futureComments,
                  showComments: _showComments,
                ),
              ],
            ),
          ),
          // Reply Widget
          BottomCommentBar(
            expressionAddress: widget.comment.address,
            openComments: _openComments,
            refreshComments: _refreshComments,
            scrollToBottom: _scrollToBottom,
            focusNode: _focusNode,
          ),
        ],
      ),
    );
  }
}
