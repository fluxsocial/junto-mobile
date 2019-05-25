import 'package:flutter/material.dart';

import '../../typography/palette.dart';
import '../../typography/style.dart';
import './create_actions.dart';

class Longform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(children: [
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 20, bottom: 20),
        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
        width: MediaQuery.of(context).size.width,
        child: Text('LONGFORM',
            textAlign: TextAlign.start, style: JuntoStyles.lotusExpressionType),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
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
      Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * .7,
              ),
              child: TextField(
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
          ])),

          CreateActions()
    ]);
  }
}
