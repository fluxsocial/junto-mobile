import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';

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
  TextEditingController _titleController;
  TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  /// Creates a [LongFormExpression] from the given data entered
  /// by the user.
  LongFormExpression createExpression() {
    return LongFormExpression(
      body: _bodyController.value.text,
      title: _titleController.value.text,
    );
  }

  bool validate() {
    // Body cannot be empty if the title is also empty
    if (_titleController.value.text.isEmpty) {
      return _bodyController.value.text.isNotEmpty;
    }
    // Body can be empty if the title is not empty
    if (_titleController.value.text.isNotEmpty) {
      return true;
    }
    // Title can be empty if the title is not empty
    if (_bodyController.value.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _onNext() {
    if (validate() == true) {
      final LongFormExpression expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return CreateActions(
              expressionType: ExpressionType.dynamic,
              address: widget.address,
              expressionContext: widget.expressionContext,
              expression: expression,
            );
          },
        ),
      );
    } else {
      //todo: replace with less intrusive form
      JuntoDialog.showJuntoDialog(
        context,
        'Please ensure all required fields are filled.',
        <Widget>[
          DialogBack(),
        ],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      onNext: _onNext,
      child: Flexible(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Container(
              child: TextField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write a title (optional)',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.black54),
                ),
                cursorColor: JuntoPalette.juntoGrey,
                cursorWidth: 2,
                maxLines: null,
                style: Theme.of(context).textTheme.headline6,
                keyboardAppearance: Theme.of(context).brightness,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * .7,
              ),
              child: TextField(
                controller: _bodyController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                ),
                cursorColor: Theme.of(context).primaryColorLight,
                cursorWidth: 2,
                maxLines: null,
                style: Theme.of(context).textTheme.caption,
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
