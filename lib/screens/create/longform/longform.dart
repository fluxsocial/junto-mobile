import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';
import '../create_actions.dart';

class CreateLongform extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateLongformState();
  }
}

class CreateLongformState extends State<CreateLongform> {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _bodyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var _titleValue = _titleController.text;
    var _bodyValue = _bodyController.text;

    Map _longformExpression = {
      'expression': {
        'expression_type': 'longform',
        'expression_data': {
          'LongForm': {
            'title': _titleValue,
            'body': _bodyValue
          }
        }                        
      },
      'tags': ['holochainjjjjjjjjjjj', 'holochainjjjjjjjjjjj', 'holochainjjjjjjjjjjj'],
      'context': ['dna']      
    };

    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _titleController,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title (optional)',
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.lotusLongformTitle,
                      maxLines: 1,
                      maxLength: 80,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * .7,
                    ),
                    child: TextField(
                      controller: _bodyController,
                      keyboardType: TextInputType.multiline,
                      // textInputAction: TextInputAction,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      maxLines: null,
                      style: JuntoStyles.lotusLongformBody,
                    ),
                  ),
                ]),
          ),

          CreateActions(_longformExpression)
        ],
      ),
    );
  }
}
