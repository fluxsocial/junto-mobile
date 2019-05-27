import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';

class Longform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Expanded(
        child: ListView(            
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
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
          ]));
  }
}
