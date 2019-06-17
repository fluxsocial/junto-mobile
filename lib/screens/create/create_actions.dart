
import 'package:flutter/material.dart';

import '../../typography/style.dart';

class CreateActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      GestureDetector(
        onVerticalDragDown: (details) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },

        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffeeeeee), width: 1))),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  width: MediaQuery.of(context).size.width * .5 - 10,
                  child: Text('# CHANNELS', style: JuntoStyles.lotusAddChannels),
                  alignment: Alignment.center,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * .5 - 10,
                  child: Text('CREATE', style: JuntoStyles.lotusAddChannels),
                  alignment: Alignment.center,

                ),                
          ]),
        ),
      );
  }
}
