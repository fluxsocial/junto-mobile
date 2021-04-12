import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
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
    @required this.stopPlayback,
  }) : super(key: key);
  final dynamic expression;
  final String expressionAddress;
  final Function refreshComments;
  final Function openComments;
  final Function scrollToBottom;
  final FocusNode focusNode;
  final VoidCallback stopPlayback;

  @override
  BottomCommentBarState createState() => BottomCommentBarState();
}

enum MessageType { regular, gif }

class BottomCommentBarState extends State<BottomCommentBar>
    with CreateExpressionHelpers {
  String selectedUrl;
  TextEditingController commentController;
  List<Map<String, dynamic>> addedmentions = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> completeUserList = [];
  List<Map<String, dynamic>> addedChannels = [];
  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> completeChannelsList = [];
  ListType listType = ListType.empty;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;

  Future<void> _createComment() async {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);
    final channels = getChannelsId(markupText);

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
      } on DioError catch (error) {
        print(error.message);
        print(error.response.statusMessage);
        print(error.response.statusCode);
        JuntoLoader.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText: 'Hmm, something went wrong.',
          ),
        );
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

  void toggleSearch(bool value) {
    if (value != _showList) {
      setState(() {
        _showList = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: BlocConsumer<SearchBloc, SearchState>(
        buildWhen: (prev, cur) {
          return !(cur is LoadingSearchState ||
              cur is LoadingSearchChannelState);
        },
        listener: (context, state) {
          if (!(state is LoadingSearchState) && (state is SearchUserState)) {
            final eq = DeepCollectionEquality.unordered().equals;

            final _users = getUserList(state, []);

            final isEqual = eq(users, _users);

            if (!isEqual) {
              setState(() {
                users = _users;

                listType = ListType.mention;

                completeUserList = generateFinalList(completeUserList, _users);
              });
            }
          }

          if (!(state is LoadingSearchChannelState) &&
              (state is SearchChannelState)) {
            final eq = DeepCollectionEquality.unordered().equals;

            final _channels = getChannelsList(state, []);

            final isEqual = eq(channels, _channels);

            if (!isEqual) {
              setState(() {
                channels = _channels;

                listType = ListType.channels;

                completeChannelsList =
                    generateFinalList(completeChannelsList, _channels);
              });
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: Column(
              children: [
                if (_showList && listType == ListType.mention)
                  MentionsSearchList(
                    userList: users,
                    onMentionAdd: (index) {
                      mentionKey.currentState.addMention(users[index]);

                      if (addedmentions.indexWhere((element) =>
                              element['id'] == users[index]['id']) ==
                          -1) {
                        addedmentions = [...addedmentions, users[index]];
                      }

                      setState(() {
                        _showList = false;
                        users = [];
                      });
                    },
                  ),
                if (_showList && listType == ListType.channels)
                  ChannelsSearchList(
                    channels: channels,
                    onChannelAdd: (index) {
                      mentionKey.currentState.addMention(channels[index]);

                      if (addedChannels.indexWhere((element) =>
                              element['id'] == channels[index]['id']) ==
                          -1) {
                        addedChannels = [...addedChannels, channels[index]];
                      }

                      setState(() {
                        _showList = false;
                        channels = [];
                      });
                    },
                  ),
                Consumer<AppRepo>(builder: (context, snapshot, _) {
                  return Container(
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
                            widget.stopPlayback();
                            showModalBottomSheet(
                              enableDrag: false,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0,
                                      AppBar().preferredSize.height / 2, 0, 0),
                                  child: FadeIn(
                                    duration: Duration(milliseconds: 300),
                                    child: FeatureDiscovery(
                                      child: CreateCommentExpressionScaffold(
                                        expressionContext:
                                            snapshot.expressionContext ??
                                                ExpressionContext.Comment,
                                        group: snapshot.group,
                                        commentAddress:
                                            widget.expressionAddress,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              context: context,
                            ).then((value) {
                              widget.refreshComments();
                            });
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
                                      if (value.isNotEmpty && _showList) {
                                        final channel = trigger == '#';

                                        if (!channel) {
                                          context
                                              .bloc<SearchBloc>()
                                              .add(SearchingEvent(
                                                value,
                                                QueryUserBy.BOTH,
                                              ));
                                        } else {
                                          context.bloc<SearchBloc>().add(
                                              SearchingChannelEvent(value));
                                        }
                                      } else {
                                        setState(() {
                                          users = [];
                                          channels = [];
                                          listType = ListType.empty;
                                          _showList = false;
                                        });
                                      }
                                    },
                                    mentions: getMention(
                                      context,
                                      [...addedmentions, ...completeUserList],
                                      [
                                        ...addedChannels,
                                        ...completeChannelsList
                                      ],
                                    ),
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
                                    onSuggestionVisibleChanged: toggleSearch,
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
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
