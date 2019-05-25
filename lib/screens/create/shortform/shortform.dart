
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';
import './../create_actions.dart';

class Shortform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return 
      Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              width: MediaQuery.of(context).size.width,
              child: Text('SHORTFORM',
                  textAlign: TextAlign.start, style: JuntoStyles.lotusExpressionType),
            ),



                // CreateActions()
          ]);    
    
  }
}

