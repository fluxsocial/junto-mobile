import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
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
    return LongFormExpression(
      body: _bodyController.value.text.trim(),
      title: _titleController.value.text.trim(),
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
      create: (BuildContext context) => SearchBloc(
        Provider.of<SearchRepo>(context, listen: false),
      ),
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
              BlocBuilder<SearchBloc, dynamic>(
                builder: (BuildContext context, dynamic state) {
                  return FlutterMentions(
                    suggestionPosition: SuggestionPosition.Bottom,
                    maxLines: 5,
                    minLines: 1,
                    onMarkupChanged: (name) {
                      context.bloc<SearchBloc>().add(
                            SearchingEvent(
                              name,
                              true,
                            ),
                          );
                    },
                    mentions: [
                      Mention(
                          trigger: "@",
                          style: TextStyle(color: Colors.purple),
                          data: [{}],
                          suggestionBuilder: (data) {
                            return Container(
                              color: Colors.red,
                              child: Text(data['display']),
                            );
                          })
                    ],
                  );
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).backgroundColor,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * .7,
                      ),
                      child: TextField(
                        focusNode: _bodyFocus,
                        controller: _bodyController,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write here...',
                        ),
                        cursorColor: Theme.of(context).primaryColorLight,
                        cursorWidth: 2,
                        maxLines: null,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: 17,
                            ),
                        keyboardAppearance: Theme.of(context).brightness,
                        textCapitalization: TextCapitalization.sentences,
//                      keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ],
                ),
              ),
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
