
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('# ADD CHANNELS',
                style: JuntoStyles.lotusAddChannels),
            Text('CREATE',
                style: JuntoStyles.lotusCreate)
          ]),
        ),
      );
  }
}
