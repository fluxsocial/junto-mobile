import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

class CreateLinkForm extends StatefulWidget {
  const CreateLinkForm({
    Key key,
    this.captionFocus,
    this.urlFocus,
  }) : super(key: key);

  final FocusNode captionFocus;
  final FocusNode urlFocus;

  @override
  State<StatefulWidget> createState() => CreateLinkFormState();
}

class CreateLinkFormState extends State<CreateLinkForm>
    with CreateExpressionHelpers, AutomaticKeepAliveClientMixin {
  String caption;
  String url;
  String title;

  TextEditingController _titleController;
  TextEditingController _urlController;

  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> completeUserList = [];
  List<Map<String, dynamic>> addedChannels = [];
  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> completeChannelsList = [];
  ListType listType = ListType.empty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  LinkFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;

    return LinkFormExpression(
      caption: markupText.trim(),
      title: appConfig.flavor == Flavor.prod
          ? ''
          : _titleController.value.text.trim(),
      url: _urlController.value.text.trim(),
      data: null,
    );
  }

  Map<String, List<String>> getMentionsAndChannels() {
    final LinkFormExpression expression = createExpression();
    final mentions = getMentionUserId(expression.caption);
    final channels = getChannelsId(expression.caption);
    return {'mentions': mentions, 'channels': channels};
  }

  bool validate() {
    final text = _urlController.value.text.toLowerCase().trim();
    if (text.startsWith('http://') || text.startsWith('https://')) {
      return true;
    } else if (text.startsWith('www.')) {
      _urlController.value = TextEditingValue(text: 'https://$text');
      return true;
    } else {
      return false;
    }
  }

  bool expressionHasData() {
    final LinkFormExpression expression = createExpression();
    if (expression.caption.isNotEmpty ||
        expression.title.isNotEmpty ||
        expression.url.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
      child: Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocConsumer<SearchBloc, SearchState>(
            buildWhen: (prev, cur) {
              return !(cur is LoadingSearchState ||
                  cur is LoadingSearchChannelState);
            },
            listener: (context, state) {
              if (!(state is LoadingSearchState) &&
                  (state is SearchUserState)) {
                final eq = DeepCollectionEquality.unordered().equals;

                final _users = getUserList(state, []);

                final isEqual = eq(users, _users);

                if (!isEqual) {
                  setState(() {
                    users = _users;

                    listType = ListType.mention;

                    completeUserList =
                        generateFinalList(completeUserList, _users);
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
              return Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // if (appConfig.flavor == Flavor.dev)
                        //   Container(
                        //     child: TextField(
                        //       buildCounter: (
                        //         BuildContext context, {
                        //         int currentLength,
                        //         int maxLength,
                        //         bool isFocused,
                        //       }) =>
                        //           null,
                        //       controller: _titleController,
                        //       textInputAction: TextInputAction.done,
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         hintText: 'Title (optional)',
                        //         hintStyle: Theme.of(context)
                        //             .textTheme
                        //             .headline6
                        //             .copyWith(
                        //               color:
                        //                   Theme.of(context).primaryColorLight,
                        //             ),
                        //       ),
                        //       cursorColor: Theme.of(context).primaryColor,
                        //       cursorWidth: 2,
                        //       maxLines: null,
                        //       maxLength: 140,
                        //       style: Theme.of(context).textTheme.headline6,
                        //       keyboardAppearance: Theme.of(context).brightness,
                        //       textCapitalization: TextCapitalization.sentences,
                        //       keyboardType: TextInputType.text,
                        //     ),
                        //   ),
                        Container(
                          child: FlutterMentions(
                            key: mentionKey,
                            focusNode: widget.captionFocus,
                            onSearchChanged: (String trigger, String value) {
                              if (value.isNotEmpty && _showList) {
                                final channel = trigger == '#';

                                if (!channel) {
                                  context.bloc<SearchBloc>().add(SearchingEvent(
                                        value,
                                        QueryUserBy.BOTH,
                                      ));
                                } else {
                                  context
                                      .bloc<SearchBloc>()
                                      .add(SearchingChannelEvent(value));
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
                            onSuggestionVisibleChanged: toggleSearch,
                            hideSuggestionList: true,
                            mentions: getMention(
                              context,
                              [...addedmentions, ...completeUserList],
                              [...addedChannels, ...completeChannelsList],
                            ),
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) =>
                                null,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Caption (optional)',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                            ),
                            maxLines: null,
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                            keyboardAppearance: Theme.of(context).brightness,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        Container(
                          child: TextField(
                            focusNode: widget.urlFocus,
                            buildCounter: (
                              BuildContext context, {
                              int currentLength,
                              int maxLength,
                              bool isFocused,
                            }) =>
                                null,
                            maxLines: null,
                            controller: _urlController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Link',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            cursorWidth: 2,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                            keyboardAppearance: Theme.of(context).brightness,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    if (_showList &&
                        widget.captionFocus.hasFocus &&
                        listType == ListType.mention)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: MentionsSearchList(
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
                      ),
                    if (_showList &&
                        widget.captionFocus.hasFocus &&
                        listType == ListType.channels)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: ChannelsSearchList(
                          channels: channels,
                          onChannelAdd: (index) {
                            mentionKey.currentState.addMention(channels[index]);

                            if (addedChannels.indexWhere((element) =>
                                    element['id'] == channels[index]['id']) ==
                                -1) {
                              addedChannels = [
                                ...addedChannels,
                                channels[index]
                              ];
                            }

                            setState(() {
                              _showList = false;
                              channels = [];
                            });
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
