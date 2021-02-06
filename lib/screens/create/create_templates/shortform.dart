import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

/// Allows the user to create a short form expression.
class CreateShortform extends StatefulWidget {
  const CreateShortform({
    Key key,
    this.expressionContext,
    this.address,
    this.shortformFocus,
  }) : super(key: key);

  final ExpressionContext expressionContext;
  final String address;
  final FocusNode shortformFocus;

  @override
  State<StatefulWidget> createState() => CreateShortformState();
}

class CreateShortformState extends State<CreateShortform>
    with CreateExpressionHelpers {
  final FocusNode _focus = FocusNode();
  String gradientOne;
  String gradientTwo;
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

  /// Creates a [ShortFormExpression] from the given data entered
  /// by the user.
  ShortFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;

    return ShortFormExpression(
      body: markupText.trim(),
      background: <dynamic>[gradientOne, gradientTwo],
    );
  }

  Map<String, List<String>> getMentionsAndChannels() {
    final ShortFormExpression expression = createExpression();
    final mentions = getMentionUserId(expression.body);
    final channels = getChannelsId(expression.body);
    return {'mentions': mentions, 'channels': channels};
  }

  bool expressionHasData() {
    final body = mentionKey.currentState.controller.text;
    return body != null && body.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    gradientOne = 'fff8ee';
    gradientTwo = 'ffeee0';
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void toggleSearch(bool value) {
    if (value != _showList) {
      setState(() {
        _showList = value;
      });
    }
  }

  Widget _gradientSelector(String hexOne, String hexTwo) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gradientOne = hexOne;
          gradientTwo = hexTwo;
        });
      },
      child: Container(
        height: 38,
        width: 38,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.2, 0.9],
            colors: <Color>[
              HexColor.fromHex(hexOne),
              HexColor.fromHex(hexTwo),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: Expanded(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  height: 58,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _gradientSelector('fff8ee', 'ffeee0'),
                      _gradientSelector('222222', '555555'),
                      _gradientSelector('2E4F78', '6397C7'),
                      _gradientSelector('2034BC', 'BD96D6'),
                      _gradientSelector('6F51A8', 'E8B974'),
                      _gradientSelector('719cf4', 'ffc7e4'),
                      _gradientSelector('639acf', '7bdaa5'),
                      _gradientSelector('E7E26E', '2CBAB1'),
                      _gradientSelector('FC6073', 'FFD391'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Form(
                        autovalidateMode: AutovalidateMode.disabled,
                        child: BlocConsumer<SearchBloc, SearchState>(
                          buildWhen: (prev, cur) {
                            return !(cur is LoadingSearchState ||
                                cur is LoadingSearchChannelState);
                          },
                          listener: (context, state) {
                            if (!(state is LoadingSearchState) &&
                                (state is SearchUserState)) {
                              final eq =
                                  DeepCollectionEquality.unordered().equals;

                              final _users = getUserList(state, []);

                              final isEqual = eq(users, _users);

                              if (!isEqual) {
                                setState(() {
                                  users = _users;

                                  listType = ListType.mention;

                                  completeUserList = generateFinalList(
                                      completeUserList, _users);
                                });
                              }
                            }

                            if (!(state is LoadingSearchChannelState) &&
                                (state is SearchChannelState)) {
                              final eq =
                                  DeepCollectionEquality.unordered().equals;

                              final _channels = getChannelsList(state, []);

                              final isEqual = eq(channels, _channels);

                              if (!isEqual) {
                                setState(() {
                                  channels = _channels;

                                  listType = ListType.channels;

                                  completeChannelsList = generateFinalList(
                                      completeChannelsList, _channels);
                                });
                              }
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  widget.shortformFocus.requestFocus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 50.0,
                                    horizontal: 25.0,
                                  ),
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.width,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      stops: const <double>[
                                        0.2,
                                        0.9,
                                      ],
                                      colors: <Color>[
                                        HexColor.fromHex(gradientOne),
                                        HexColor.fromHex(gradientTwo),
                                      ],
                                    ),
                                  ),
                                  child: FlutterMentions(
                                    key: mentionKey,
                                    focusNode: widget.shortformFocus,
                                    autofocus: false,
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
                                    onSuggestionVisibleChanged: toggleSearch,
                                    hideSuggestionList: true,
                                    mentions: getMention(
                                      context,
                                      [...addedmentions, ...completeUserList],
                                      [
                                        ...addedChannels,
                                        ...completeChannelsList
                                      ],
                                    ),
                                    buildCounter: (
                                      BuildContext context, {
                                      int currentLength,
                                      int maxLength,
                                      bool isFocused,
                                    }) =>
                                        null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Write here...',
                                    ),
                                    cursorColor: gradientOne.contains('fff') ||
                                            gradientTwo.contains('fff')
                                        ? Color(0xff333333)
                                        : Colors.white,
                                    cursorWidth: 2,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: gradientOne.contains('fff') ||
                                              gradientTwo.contains('fff')
                                          ? Color(0xff333333)
                                          : Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLength: 220,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.done,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardAppearance:
                                        Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showList &&
                widget.shortformFocus.hasFocus &&
                listType == ListType.mention)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: MentionsSearchList(
                  userList: users,
                  onMentionAdd: (index) {
                    mentionKey.currentState.addMention(users[index]);

                    if (addedmentions.indexWhere(
                            (element) => element['id'] == users[index]['id']) ==
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
                widget.shortformFocus.hasFocus &&
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
                      addedChannels = [...addedChannels, channels[index]];
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
      ),
    );
  }
}
