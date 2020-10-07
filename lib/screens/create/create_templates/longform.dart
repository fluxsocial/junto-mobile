import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

class CreateLongform extends StatefulWidget {
  const CreateLongform({Key key, this.expressionContext, this.address})
      : super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return CreateLongformState();
  }
}

class CreateLongformState extends State<CreateLongform>
    with CreateExpressionHelpers {
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  bool _showBottomNav = true;
  TextEditingController _titleController;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];

  void toggleBottomNav() {
    setState(() {
      _showBottomNav = !_showBottomNav;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleFocus.addListener(toggleBottomNav);
    _bodyFocus.addListener(toggleBottomNav);
  }

  /// Creates a [LongFormExpression] from the given data entered
  /// by the user.
  LongFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);

    return LongFormExpression(
      title: _titleController.value.text.trim(),
      body: markupText.trim(),
      mentions: mentions,
    );
  }

  bool expressionHasData() {
    final body = mentionKey.currentState.controller.text.trim();
    final title = _titleController.value.text.trim();
    // Body cannot be empty if the title is also empty
    if (title.isEmpty) {
      return body.isNotEmpty;
    }
    // Body can be empty if the title is not empty
    if (title.isNotEmpty) {
      return true;
    }
    // Title can be empty if the title is not empty
    if (body.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _onNext() {
    if (expressionHasData() == true) {
      final LongFormExpression expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            if (widget.expressionContext == ExpressionContext.Comment) {
              return CreateCommentActions(
                expression: expression,
                address: widget.address,
                expressionType: ExpressionType.dynamic,
              );
            } else {
              return CreateActions(
                expressionType: ExpressionType.dynamic,
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
            dialogText: 'Please fill in the required fields.'),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _titleFocus.dispose();
    _bodyFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: CreateExpressionScaffold(
        showBottomNav: _showBottomNav,
        expressionType: ExpressionType.dynamic,
        onNext: _onNext,
        expressionHasData: expressionHasData,
        child: Container(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final _users = getUserList(state, []);

              final _finalList = [...addedmentions, ..._users];

              return Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        focusNode: _titleFocus,
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        controller: _titleController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle:
                              Theme.of(context).textTheme.headline6.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        cursorWidth: 2,
                        maxLines: null,
                        maxLength: 140,
                        style: Theme.of(context).textTheme.headline6,
                        keyboardAppearance: Theme.of(context).brightness,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FlutterMentions(
                              key: mentionKey,
                              suggestionPosition: SuggestionPosition.Bottom,
                              minLines: 1,
                              maxLines: 20,
                              keyboardAppearance: Theme.of(context).brightness,
                              cursorWidth: 2,
                              focusNode: _bodyFocus,
                              textInputAction: TextInputAction.newline,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 17),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Write here...',
                              ),
                              onChanged: (value) {
                                print(value);
                              },
                              onSearchChanged: (String trigger, String value) {
                                context
                                    .bloc<SearchBloc>()
                                    .add(SearchingEvent(value, true));
                              },
                              onSuggestionVisibleChanged: (val) {
                                setState(() {
                                  _showList = val;
                                });
                              },
                              hideSuggestionList: true,
                              mentions: [
                                Mention(
                                  trigger: '@',
                                  data: [..._finalList],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  markupBuilder: (trigger, mention, value) {
                                    return '[$trigger$value:$mention]';
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (_showList && _bodyFocus.hasFocus)
                            MentionsSearchList(
                              userList: _users,
                              onMentionAdd: (index) {
                                mentionKey.currentState
                                    .addMention(_finalList[index]);

                                if (addedmentions.indexWhere((element) =>
                                        element['id'] ==
                                        _finalList[index]['id']) ==
                                    -1) {
                                  addedmentions = [
                                    ...addedmentions,
                                    _finalList[index]
                                  ];
                                }

                                setState(() {
                                  _showList = false;
                                });
                              },
                            ),
                        ],
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
}
