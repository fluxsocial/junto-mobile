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

  /// Creates a [CentralizedLongFormExpression] from the given data entered
  /// by the user.
  CentralizedLongFormExpression createExpression() {
    return CentralizedLongFormExpression(
      body: _bodyController.value.text,
      title: _titleController.value.text,
    );
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
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'write a title (optional)'),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      style: Theme.of(context).textTheme.title),
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * .7,
                  ),
                  child: TextField(
                    controller: _bodyController,
                    // keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    cursorColor: JuntoPalette.juntoGrey,
                    cursorWidth: 2,
                    maxLines: null,
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
