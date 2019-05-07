
import 'package:flutter/material.dart';

import '../../screens/collective/collective.dart';
import '../../custom_icons.dart';
import '../../typography/palette.dart';

class BottomNavCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
    Container(        
      height: 90,
      // color: Colors.orange,
      child: 

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: 
              [
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                    
                    children: <Widget>[
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.moon, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.home, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.home, color: JuntoPalette.juntoSleek)),                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.home, color: JuntoPalette.juntoSleek)),
                      Container(margin: EdgeInsets.symmetric(horizontal: 25.0), child: Icon(CustomIcons.home, color: JuntoPalette.juntoSleek)),

                    ],
                  ),
                ),

            Container(
              alignment: Alignment.center,
              height: 45,
              color: Colors.white,
              // margin: EdgeInsets.only(top: 15.0),
              child: IconButton(

                onPressed: () => Navigator.pop(context),
                icon: Icon(CustomIcons.lotus, color: JuntoPalette.juntoBlue, size: 30))                              
            ),
          ]
        ),
    );
  }
}
