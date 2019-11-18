import 'dart:async' show Timer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/palette.dart';
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
import 'package:provider/provider.dart';

class ExpressionOpen extends StatefulWidget {
  const ExpressionOpen(this.expression);

  final CentralizedExpressionResponse expression;

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

  // privacy layer of the comment
  String _commentPrivacy = 'public';

  // Create a controller for the comment text field
  TextEditingController commentController;

  // Boolean that signals whether the member can create a comment or not
  ValueNotifier<bool> createComment = ValueNotifier<bool>(false);

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

  // Open modal bottom sheet and refocus TextField after dismissed
  Future<void> _showPrivacyModalSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.transparent,
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

  void _onTextChange(String value) {
    if (value.isEmpty) {
      createComment.value = false;
    } else if (value.isNotEmpty) {
      createComment.value = true;
    }
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
    try {
      await Provider.of<ExpressionRepo>(context).postCommentExpression(
        widget.expression.address,
        'LongForm',
        CentralizedLongFormExpression(
          title: 'Expression Comment',
          body: commentController.value.text,
        ).toMap(),
      );
      commentController.clear();
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
                  ExpressionOpenBottom(widget.expression, _focusTextField),
                  GestureDetector(
                    onTap: _showComments,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Show replies (${comments.length})',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12),
                          ),
                          const SizedBox(width: 5),
                          if (commentsVisible == false)
                            Icon(Icons.keyboard_arrow_down,
                                size: 14,
                                color: Theme.of(context).primaryColor),
                          if (commentsVisible != false)
                            Icon(Icons.keyboard_arrow_up,
                                size: 17,
                                color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                  if (commentsVisible)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommentPreview(
                          parent: widget.expression,
                          commentText: comments[index],
                        );
                      },
                    )
                ],
              ),
            ),
          ),
          _BottomCommentBar(
            postComment: _createComment,
            commentController: commentController,
            commentPrivacy: _commentPrivacy,
            focusNode: _focusNode,
            onTextChange: _onTextChange,
            showPrivacySheet: () async {
              await _showPrivacyModalSheet();
            },
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
    @required this.onTextChange,
    @required this.commentController,
    @required this.showPrivacySheet,
    @required this.commentPrivacy,
    @required this.onGifSelected,
    @required this.postComment,
  }) : super(key: key);
  final FocusNode focusNode;
  final ValueChanged<String> onTextChange;
  final TextEditingController commentController;
  final VoidCallback showPrivacySheet;
  final String commentPrivacy;
  final ValueChanged<String> onGifSelected;
  final VoidCallback postComment;

  @override
  _BottomCommentBarState createState() => _BottomCommentBarState();
}

enum MessageType { regular, gif }

class _BottomCommentBarState extends State<_BottomCommentBar> {
  final ValueNotifier<MessageType> _type =
      ValueNotifier<MessageType>(MessageType.regular);
  String selectedUrl;

  Widget _createCommentIcon(bool createComment) {
    if (createComment == true) {
      return GestureDetector(
        onTap: widget.postComment,
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
        child: ValueListenableBuilder<MessageType>(
            valueListenable: _type,
            builder: (BuildContext context, MessageType type, _) {
              return Column(
                children: <Widget>[
                  if (type == MessageType.gif && selectedUrl != null)
                    SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: CachedNetworkImage(
                        placeholder: (BuildContext context, String _) {
                          return Image.asset(
                            'assets/images/junto-mobile__placeholder--member.png',
                          );
                        },
                        imageUrl: selectedUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 4.0),
                  _buildCommentRow(context),
                  _buildBottomStrip()
                ],
              );
            }),
      ),
    );
  }

  Widget _buildBottomStrip() {
    return AnimatedBuilder(
      animation: widget.focusNode,
      builder: (BuildContext context, _) {
        if (widget.focusNode.hasFocus)
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: widget.showPrivacySheet,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.commentPrivacy,
                            style: Theme.of(context).textTheme.body2),
                        Icon(Icons.keyboard_arrow_down,
                            size: 14, color: Theme.of(context).primaryColorDark)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      builder: (BuildContext context) => _GiphyPanel(
                        onGifSelected: (String selected) {
                          selectedUrl = selected;
                          _type.value = MessageType.gif;
                          widget.onGifSelected(selected);
                        },
                      ),
                    );
                  },
                  child: const Text('GIF'),
                ),
              ],
            ),
          );
        return const SizedBox();
      },
    );
  }

  Row _buildCommentRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
            ),
            width: widget.focusNode.hasFocus
                ? MediaQuery.of(context).size.width - 100
                : MediaQuery.of(context).size.width - 68,
            constraints: const BoxConstraints(maxHeight: 180),
            child: Container(
              width: MediaQuery.of(context).size.width - 140,
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.commentController,
                onChanged: widget.onTextChange,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                maxLines: null,
                cursorColor: JuntoPalette.juntoGrey,
                cursorWidth: 2,
                style: Theme.of(context).textTheme.caption,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: AnimatedBuilder(
            animation: widget.focusNode,
            builder: (BuildContext context, _) {
              return _createCommentIcon(
                widget.focusNode.hasFocus,
              );
            },
          ),
        )
      ],
    );
  }
}

class _GiphyPanel extends StatefulWidget {
  const _GiphyPanel({Key key, @required this.onGifSelected}) : super(key: key);
  final ValueChanged<String> onGifSelected;

  @override
  _GiphyPanelState createState() => _GiphyPanelState();
}

class _GiphyPanelState extends State<_GiphyPanel> {
  final GiphyClient client = GiphyClient(apiKey: kGiphyApi);
  GiphyCollection gifs;
  Timer _searchTimer;
  final ValueNotifier<String> _query = ValueNotifier<String>(null);

  /// Waits 500 milliseconds before calling the server with the given query.
  void onTextChange(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _query.value = query;
    });
  }

  /// Returns a collection of trending gifs.
  Future<GiphyCollection> getGifs() async {
    return client.trending();
  }

  /// Returns a collection of gifs that matchs the given [query]
  Future<GiphyCollection> searchGifs(String query) async {
    if (query != null && query.isNotEmpty) {
      final GiphyCollection giphs = await client.search(query);
      return giphs;
    } else {
      return await getGifs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                decoration: const InputDecoration(hintText: 'Search Giphy...'),
                onChanged: onTextChange,
              ),
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: _query,
            builder: (BuildContext context, String term, _) {
              return FutureBuilder<GiphyCollection>(
                future: searchGifs(term),
                builder: (BuildContext context,
                    AsyncSnapshot<GiphyCollection> snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(child: Container());
                  }
                  if (snapshot.hasError) {
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.red,
                      ),
                    );
                  }
                  final GiphyCollection _data = snapshot.data;
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final GiphyGif _gifs = _data.data[index];

                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            widget.onGifSelected(_gifs.images.downsized.url);
                          },
                          child: CachedNetworkImage(
                            placeholder: (BuildContext context, String _) {
                              return Image.asset(
                                'assets/images/junto-mobile__placeholder--member.png',
                              );
                            },
                            imageUrl: _gifs.images.downsized.url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      childCount: _data.data.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
