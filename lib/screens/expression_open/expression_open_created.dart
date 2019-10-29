import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_appbar.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_bottom.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_top.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/event_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/longform_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/photo_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/shortform_open.dart';
import 'package:junto_beta_mobile/widgets/previews/comment_preview.dart';

class ExpressionOpenCreated extends StatefulWidget {
  const ExpressionOpenCreated(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenCreatedState();
  }
}

class ExpressionOpenCreatedState extends State<ExpressionOpenCreated> {
  final GlobalKey<ExpressionOpenCreatedState> _keyFlexibleSpace =
      GlobalKey<ExpressionOpenCreatedState>();

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

    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
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
        child: const Icon(
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

  double _flexibleHeightSpace;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;
    print(heightFlexibleSpace);

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: ExpressionOpenAppbar(),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        DefaultTabController(
          length: 2,
          child: GestureDetector(
            onVerticalDragDown: _onDragDown,
            child: NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    brightness: Brightness.light,
                    automaticallyImplyLeading: false,
                    primary: false,
                    actions: const <Widget>[SizedBox(height: 0, width: 0)],
                    backgroundColor: Colors.white,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        children: <Widget>[
                          ExpressionOpenTop(expression: widget.expression),
                          Container(
                              key: _keyFlexibleSpace,
                              child: _buildExpression()),
                          ExpressionOpenBottom(widget.expression),
                        ],
                      ),
                    ),
                    expandedHeight: _flexibleHeightSpace == null
                        ? 100000
                        : _flexibleHeightSpace + 123,
                    forceElevated: false,
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelPadding: const EdgeInsets.all(0),
                        isScrollable: true,
                        labelColor: const Color(0xff333333),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff333333),
                        ),
                        indicatorWeight: 0.0001,
                        tabs: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            color: Colors.white,
                            child: const Tab(
                              text: 'Public Replies',
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: const Tab(
                              text: 'Private Replies',
                            ),
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: <Widget>[
                            CommentPreview(
                              parent: widget.expression,
                              commentText:
                                  'Hey there! This is what a comment preview looks like.',
                            ),
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
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: <Widget>[
                            CommentPreview(
                              parent: widget.expression,
                              commentText:
                                  'Hey there! This is what a comment preview looks like.',
                            ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.only(left: 15),
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
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _commentPrivacy,
                                      style: const TextStyle(
                                          color: Color(0xff333333),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down,
                                        size: 14)
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
        ),
      ]),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + .5;

  @override
  double get maxExtent => _tabBar.preferredSize.height + .5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
