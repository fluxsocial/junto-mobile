import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';

class CreateLongform extends StatefulWidget {
  const CreateLongform({Key key}) : super(key: key);

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

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
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
                        hintStyle: Theme.of(context).textTheme.headline6),
                    cursorColor: JuntoPalette.juntoGrey,
                    cursorWidth: 2,
                    maxLines: null,
                    style: Theme.of(context).textTheme.headline6,
                    keyboardAppearance: Theme.of(context).brightness,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
