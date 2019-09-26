import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';

class CreateLongform extends StatefulWidget {
  const CreateLongform({Key key, @required this.isEditing}) : super(key: key);
  final ValueNotifier<bool> isEditing;

  @override
  State<StatefulWidget> createState() {
    return CreateLongformState();
  }
}

class CreateLongformState extends State<CreateLongform> {
  TextEditingController _titleController;
  TextEditingController _bodyController;
  //ignore:unused_field
  String _titleValue;
  //ignore:unused_field
  String _bodyValue;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _titleValue = _titleController.text;
    _bodyValue = _bodyController.text;

    _titleController.addListener(titleListener);
    _bodyController.addListener(bodyListener);
  }

  void titleListener() {
    if (_titleController.value.text.isNotEmpty) {
      widget.isEditing.value = true;
    }
    if (_titleController.value.text.isEmpty) {
      widget.isEditing.value = false;
    }
  }

  void bodyListener() {
    if (_bodyController.value.text.isNotEmpty) {
      widget.isEditing.value = true;
    }
    if (_bodyController.value.text.isEmpty) {
      widget.isEditing.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.removeListener(titleListener);
    _bodyController.removeListener(bodyListener);
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
