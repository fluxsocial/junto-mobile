import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

class CreateLinkForm extends StatefulWidget {
  const CreateLinkForm({Key key, this.expressionContext, this.address})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => CreateLinkFormState();
}

class CreateLinkFormState extends State<CreateLinkForm> {
  FocusNode _focus;
  bool _showBottomNav = true;
  String caption;
  String url;
  String title;

  TextEditingController _titleController;
  TextEditingController _captionController;
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _captionController = TextEditingController();
    _urlController = TextEditingController();
    _focus = FocusNode();
    _focus.addListener(toggleBottomNav);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    _urlController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void toggleBottomNav() {
    setState(() {
      _showBottomNav = !_showBottomNav;
    });
  }

  LinkFormExpression createExpression() {
    return LinkFormExpression(
      caption: _captionController.value.text,
      title: appConfig.flavor == Flavor.prod ? '' : _titleController.value.text,
      url: _urlController.value.text,
    );
  }

  bool validate() {
    final text = _urlController.value.text.toLowerCase();
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
    return CreateExpressionScaffold(
      expressionType: ExpressionType.link,
      onNext: _onNext,
      showBottomNav: _showBottomNav,
      expressionHasData: expressionHasData,
      child: Expanded(
        child: ListView(
          children: <Widget>[
            if (appConfig.flavor == Flavor.dev ||
                appConfig.flavor == Flavor.tst)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                buildCounter: (
                  BuildContext context, {
                  int currentLength,
                  int maxLength,
                  bool isFocused,
                }) =>
                    null,
                controller: _captionController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Caption (optional)',
                  hintStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 2,
                maxLines: null,
                maxLength: 140,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                keyboardAppearance: Theme.of(context).brightness,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                focusNode: _focus,
                buildCounter: (
                  BuildContext context, {
                  int currentLength,
                  int maxLength,
                  bool isFocused,
                }) =>
                    null,
                controller: _urlController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Link',
                  hintStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 2,
                maxLines: null,
                maxLength: 140,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                keyboardAppearance: Theme.of(context).brightness,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
