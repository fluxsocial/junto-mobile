import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

class BottomCommentBar extends StatefulWidget {
  const BottomCommentBar({
    Key key,
    @required this.expression,
    @required this.expressionAddress,
    @required this.refreshComments,
    @required this.openComments,
    @required this.scrollToBottom,
    @required this.focusNode,
  }) : super(key: key);
  final dynamic expression;
  final String expressionAddress;
  final Function refreshComments;
  final Function openComments;
  final Function scrollToBottom;
  final FocusNode focusNode;

  @override
  BottomCommentBarState createState() => BottomCommentBarState();
}

enum MessageType { regular, gif }

class BottomCommentBarState extends State<BottomCommentBar>
    with CreateExpressionHelpers {
  String selectedUrl;
  TextEditingController commentController;
  List<Map<String, dynamic>> addedmentions = [];
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;

  Future<void> _createComment() async {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);

    print(mentions);

    if (mentionKey.currentState.controller.text != '') {
      JuntoLoader.showLoader(context);
      try {
        await Provider.of<ExpressionRepo>(context, listen: false)
            .postCommentExpression(
          widget.expressionAddress,
          'LongForm',
          LongFormExpression(
            title: '',
            body: markupText.trim(),
            mentions: mentions,
          ).toJson(),
        );
        commentController.clear();
        JuntoLoader.hide();
        widget.focusNode.unfocus();
        await showFeedback(
          context,
          icon: Icon(
            CustomIcons.newcreate,
            size: 33,
            color: Theme.of(context).primaryColor,
          ),
          message: 'Comment Created',
        );
        await widget.refreshComments();
        await widget.openComments();
        await mentionKey.currentState.controller.clear();
        await Future.delayed(Duration(milliseconds: 100));

        widget.scrollToBottom();
      } catch (error) {
        debugPrint('Error posting comment $error');
        JuntoLoader.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText: 'Hmm, something went wrong.',
          ),
        );
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final _users = getUserList(state, []);

          final _finalList = [...addedmentions, ..._users];

          return SafeArea(
            top: false,
            child: Column(
              children: [
                if (_showList)
                  MentionsSearchList(
                    userList: _users,
                    onMentionAdd: (index) {
                      mentionKey.currentState.addMention(_users[index]);

                      if (addedmentions.indexWhere((element) =>
                              element['id'] == _users[index]['id']) ==
                          -1) {
                        addedmentions = [...addedmentions, _users[index]];
                      }

                      setState(() {
                        _showList = false;
                      });
                    },
                  ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 15.0,
                    bottom: 15.0,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            FadeRoute<void>(
                              child: FeatureDiscovery(
                                child: JuntoCreate(
                                  channels: <String>[],
                                  address: widget.expressionAddress,
                                  expressionContext: ExpressionContext.Comment,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 15),
                          color: Colors.transparent,
                          child: Icon(
                            CustomIcons.create,
                            size: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          constraints: const BoxConstraints(maxHeight: 180),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlutterMentions(
                                  key: mentionKey,
                                  focusNode: widget.focusNode,
                                  suggestionPosition: SuggestionPosition.Top,
                                  onSearchChanged:
                                      (String trigger, String value) {
                                    context
                                        .bloc<SearchBloc>()
                                        .add(SearchingEvent(value, true));
                                  },
                                  mentions: [
                                    Mention(
                                      trigger: '@',
                                      data: [..._finalList],
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      markupBuilder: (trigger, mention, value) {
                                        return '[$trigger$value:$mention]';
                                      },
                                    ),
                                  ],
                                  hideSuggestionList: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'reply to ${widget.expression.creator.username}',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  maxLines: null,
                                  cursorColor: Theme.of(context).primaryColor,
                                  cursorWidth: 2,
                                  style: Theme.of(context).textTheme.caption,
                                  textInputAction: TextInputAction.newline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardAppearance:
                                      Theme.of(context).brightness,
                                  onSuggestionVisibleChanged: (val) {
                                    if (val != _showList) {
                                      setState(() {
                                        _showList = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _createComment,
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
