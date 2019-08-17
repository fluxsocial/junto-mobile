import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/typography/style.dart';

class CreateLongform extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateLongformState();
  }
}

class CreateLongformState extends State<CreateLongform> {
  TextEditingController _titleController;
  TextEditingController _bodyController;
  String _titleValue;
  String _bodyValue;

  // ignore: unused_field
  Map<String, String> _longformExpression = <String, String>{};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _titleValue = _titleController.text;
    _bodyValue = _bodyController.text;
    _longformExpression = <String, String>{
      'expression_type': 'LongForm',
      'title': _titleValue,
      'body': _bodyValue
    };
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ignore:unused_local_variable

    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   child: TextField(
                //     controller: _titleController,
                //     buildCounter: (BuildContext context,
                //             {int currentLength,
                //             int maxLength,
                //             bool isFocused}) =>
                //         null,
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       hintText: 'Title (optional)',
                //     ),
                //     cursorColor: JuntoPalette.juntoGrey,
                //     cursorWidth: 2,
                //     style: JuntoStyles.lotusLongformTitle,
                //     maxLines: 1,
                //     maxLength: 80,
                //   ),
                // ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * .7,
                  ),
                  child: TextField(
                    controller: _bodyController,
                    // keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    cursorColor: JuntoPalette.juntoGrey,
                    cursorWidth: 2,
                    maxLines: null,
                    style: JuntoStyles.lotusLongformBody,
                  ),
                ),
              ],
            ),
          ),
          // CreateActions(_longformExpression)
        ],
      ),
    );
  }
}
