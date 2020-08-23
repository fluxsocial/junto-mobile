import 'package:flutter/material.dart';
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
      title: _titleController.value.text,
      url: _urlController.value.text,
    );
  }

  bool validate() {
    final text = _urlController.value.text;
    final validUrl = RegExp(
      r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
      caseSensitive: false,
      unicode: true,
    ).hasMatch(text);
    return text != null && text.trim().isNotEmpty && validUrl;
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
                expressionType: ExpressionType.linkform,
              );
            } else {
              return CreateActions(
                expressionType: ExpressionType.linkform,
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
          dialogText: "Please enter a valid url.",
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      expressionType: ExpressionType.shortform,
      onNext: _onNext,
      showBottomNav: _showBottomNav,
      child: Expanded(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: 58,
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title...",
                ),
              ),
            ),
            Flexible(
              child: Form(
                autovalidate: false,
                child: Container(
                  height: 200.0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 50.0,
                    horizontal: 25.0,
                  ),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.width,
                  ),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xFF8E8098),
                      Color(0xFF307FAA),
                    ],
                  )),
                  child: TextField(
                    focusNode: _focus,
                    autofocus: false,
                    controller: _urlController,
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
                    cursorColor: Colors.white,
                    cursorWidth: 2,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLength: 220,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardAppearance: Theme.of(context).brightness,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: 58,
              child: TextField(
                controller: _captionController,
                decoration: InputDecoration(hintText: "Caption..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
