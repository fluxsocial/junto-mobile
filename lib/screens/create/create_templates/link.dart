import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/search_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:provider/provider.dart';

class CreateLinkForm extends StatefulWidget {
  const CreateLinkForm({Key key, this.expressionContext, this.address})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => CreateLinkFormState();
}

class CreateLinkFormState extends State<CreateLinkForm>
    with CreateExpressionHelpers {
  FocusNode _linkFocus;
  FocusNode _captionFocus;
  bool _showBottomNav = true;
  String caption;
  String url;
  String title;

  TextEditingController _titleController;
  TextEditingController _urlController;

  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
    _linkFocus = FocusNode();
    _captionFocus = FocusNode();
    _linkFocus.addListener(toggleBottomNav);
    _captionFocus.addListener(toggleBottomNav);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _linkFocus.dispose();
    _captionFocus.dispose();
    super.dispose();
  }

  void toggleBottomNav() {
    setState(() {
      _showBottomNav = !_showBottomNav;
    });
  }

  LinkFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);

    return LinkFormExpression(
      caption: markupText.trim(),
      title: appConfig.flavor == Flavor.prod
          ? ''
          : _titleController.value.text.trim(),
      url: _urlController.value.text.trim(),
      data: null,
      mentions: mentions,
    );
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

  void _onNext() {
    if (validate() == true) {
      final LinkFormExpression expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            if (widget.expressionContext == ExpressionContext.Comment) {
              return CreateCommentActions(
                expression: expression,
                address: widget.address,
                expressionType: ExpressionType.link,
              );
            } else {
              return CreateActions(
                expressionType: ExpressionType.link,
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
          dialogText:
              "Please enter a valid url. Your link must start with 'http' or 'https'",
        ),
      );
      return;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SearchBloc(Provider.of<SearchRepo>(context, listen: false));
      },
      child: CreateExpressionScaffold(
        expressionType: ExpressionType.link,
        onNext: _onNext,
        showBottomNav: _showBottomNav,
        expressionHasData: expressionHasData,
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                final _users = getUserList(state, []);

                final _finalList = [...addedmentions, ..._users];

                return Container(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          if (appConfig.flavor == Flavor.dev)
                            Container(
                              child: TextField(
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
                                  hintText: 'Title (optional)',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                ),
                                cursorColor: Theme.of(context).primaryColor,
                                cursorWidth: 2,
                                maxLines: null,
                                maxLength: 140,
                                style: Theme.of(context).textTheme.headline6,
                                keyboardAppearance:
                                    Theme.of(context).brightness,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          Container(
                            child: FlutterMentions(
                              key: mentionKey,
                              focusNode: _captionFocus,
                              onSearchChanged: (String trigger, String value) {
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
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  markupBuilder: (trigger, mention, value) {
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
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Caption (optional)',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                              ),
                              maxLines: null,
                              cursorColor: Theme.of(context).primaryColor,
                              cursorWidth: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              keyboardAppearance: Theme.of(context).brightness,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Container(
                            child: TextField(
                              focusNode: _linkFocus,
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
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              cursorWidth: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              keyboardAppearance: Theme.of(context).brightness,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      if (_showList && _captionFocus.hasFocus)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: MentionsSearchList(
                            userList: _users,
                            onMentionAdd: (index) {
                              mentionKey.currentState.addMention(_users[index]);

                              if (addedmentions.indexWhere((element) =>
                                      element['id'] == _users[index]['id']) ==
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
        ),
      ),
    );
  }
}
