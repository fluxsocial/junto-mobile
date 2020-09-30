import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_event.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
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

class CreateLongformState extends State<CreateLongform> {
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  bool _showBottomNav = true;
  TextEditingController _titleController;
  TextEditingController _bodyController;
  GlobalKey<FlutterMentionsState> metionKey = GlobalKey<FlutterMentionsState>();
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
    _bodyController = TextEditingController();
    _titleFocus.addListener(toggleBottomNav);
    _bodyFocus.addListener(toggleBottomNav);
  }

  /// Creates a [LongFormExpression] from the given data entered
  /// by the user.
  LongFormExpression createExpression() {
    final markupText = metionKey.currentState.controller.markupText;
    RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
    final match = customRegExp.allMatches(markupText).toList();
    final mentions = match.map((e) => e.group(2)).toSet().toList();

    return LongFormExpression(
      body: _bodyController.value.text.trim(),
      title: markupText.trim(),
      mentions: mentions,
    );
  }

  bool expressionHasData() {
    final body = _bodyController.value.text.trim();
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
    _bodyController.dispose();
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
        child: Expanded(
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
                    hintStyle: Theme.of(context).textTheme.headline6.copyWith(
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
              Container(child: BlocBuilder<SearchBloc, dynamic>(
                builder: (BuildContext context, dynamic state) {
                  List<Map<String, String>> _users = [];
                  if (state is LoadedSearchState) {
                    final _listUsers = state?.results;

                    _users = _listUsers.where((element) {
                      print(addedmentions
                              .indexWhere((e) => element.address == e['id']) ==
                          -1);
                      return addedmentions
                              .indexWhere((e) => element.address == e['id']) ==
                          -1;
                    }).map((e) {
                      return ({
                        'id': e.address,
                        'display': e.username,
                        'full_name': e.name,
                        'photo': ''
                      });
                    }).toList();
                  }

                  final _finalList = [...addedmentions, ..._users];

                  print("users: $_finalList");
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.7),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FlutterMentions(
                          key: metionKey,
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
                            if (value.isNotEmpty) {
                              context
                                  .bloc<SearchBloc>()
                                  .add(SearchingEvent(value, true));

                              setState(() {
                                _showList = true;
                              });
                            } else {
                              setState(() {
                                _showList = false;
                              });
                            }
                          },
                          hideSuggestionList: true,
                          mentions: [
                            Mention(
                              trigger: '@',
                              data: [..._finalList],
                              style: TextStyle(
                                color: Colors.amber,
                              ),
                              markupBuilder: (trigger, mention, value) {
                                return '[$trigger$value:$mention]';
                              },
                              suggestionBuilder: (data) {
                                return Container(
                                  color: Colors.amber,
                                  child: Text(data['display']),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_showList)
                        ListView.builder(
                          itemCount: _finalList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                metionKey.currentState
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
                              child: Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  _finalList[index]['display'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        )
                    ],
                  );
                },
              )),
              !_showBottomNav
                  ? GestureDetector(
                      onTap: () {
                        _titleFocus.unfocus();
                        _bodyFocus.unfocus();
                      },
                      onVerticalDragEnd: (dx) {
                        _titleFocus.unfocus();
                        _bodyFocus.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerRight,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            CustomIcons.back,
                            size: 15,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
