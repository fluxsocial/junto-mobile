import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

/// Allows the user to create a short form expression.
class CreateShortform extends StatefulWidget {
  const CreateShortform({Key key, this.expressionContext, this.address})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => CreateShortformState();
}

class CreateShortformState extends State<CreateShortform>
    with CreateExpressionHelpers {
  final FocusNode _focus = FocusNode();
  bool _showBottomNav = true;
  String gradientOne;
  String gradientTwo;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];

  void toggleBottomNav() {
    setState(() {
      _showBottomNav = !_showBottomNav;
    });
  }

  /// Creates a [ShortFormExpression] from the given data entered
  /// by the user.
  ShortFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);

    return ShortFormExpression(
      body: markupText.trim(),
      background: <dynamic>[gradientOne, gradientTwo],
      mentions: mentions,
    );
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
    _focus.addListener(toggleBottomNav);
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
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

  void _onNext() {
    if (expressionHasData() == true) {
      final ShortFormExpression expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            if (widget.expressionContext == ExpressionContext.Comment) {
              return CreateCommentActions(
                expression: expression,
                address: widget.address,
                expressionType: ExpressionType.shortform,
              );
            } else {
              return CreateActions(
                expressionType: ExpressionType.shortform,
                address: widget.address,
                expressionContext: widget.expressionContext,
                expression: expression,
              );
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: "Please make sure the text field isn't blank",
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: CreateExpressionScaffold(
        expressionType: ExpressionType.shortform,
        onNext: _onNext,
        showBottomNav: _showBottomNav,
        expressionHasData: expressionHasData,
        child: Expanded(
          child: Column(
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
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          final _users = getUserList(state, []);

                          final _finalList = [...addedmentions, ..._users];

                          return Container(
                            child: Stack(
                              children: [
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      _focus.requestFocus();
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
                                        focusNode: _focus,
                                        autofocus: false,
                                        onSearchChanged:
                                            (String trigger, String value) {
                                          context
                                              .bloc<SearchBloc>()
                                              .add(SearchingEvent(value, true));
                                        },
                                        onSuggestionVisibleChanged: (val) {
                                          if (val != _showList) {
                                            setState(() {
                                              _showList = val;
                                            });
                                          }
                                        },
                                        hideSuggestionList: true,
                                        mentions: [
                                          Mention(
                                            trigger: '@',
                                            data: [..._finalList],
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            markupBuilder:
                                                (trigger, mention, value) {
                                              return '[$trigger$value:$mention]';
                                            },
                                          ),
                                        ],
                                        buildCounter: (
                                          BuildContext context, {
                                          int currentLength,
                                          int maxLength,
                                          bool isFocused,
                                        }) =>
                                            null,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        cursorColor:
                                            gradientOne.contains('fff') ||
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
                                ),
                                if (_showList && _focus.hasFocus)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: MentionsSearchList(
                                      userList: _users,
                                      onMentionAdd: (index) {
                                        mentionKey.currentState
                                            .addMention(_users[index]);

                                        if (addedmentions.indexWhere(
                                                (element) =>
                                                    element['id'] ==
                                                    _users[index]['id']) ==
                                            -1) {
                                          addedmentions = [
                                            ...addedmentions,
                                            _users[index]
                                          ];
                                        }

                                        setState(() {
                                          _showList = false;
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
