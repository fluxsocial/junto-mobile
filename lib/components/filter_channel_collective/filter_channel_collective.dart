
import 'package:flutter/material.dart';

import './../../palette.dart';

class FilterChannelCollective extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return 
      // filter by channel
      Container(
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 17.0),
        width: 1000,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [

                // IconButton(
                //   splashColor: Colors.purple,
                //   onPressed: () {},
                //   color: JuntoTheme.juntoSleek,
                //   alignment: Alignment.centerLeft,
                //   icon: Icon(Icons.search),
                //   iconSize: 20.0,
                //   padding: EdgeInsets.all(0.0),
                // ),

            Container(
              margin: EdgeInsets.only(right: 5.0),
              padding: EdgeInsets.all(0),
              child: Icon(Icons.search, size: 14.0, color: JuntoPalette.juntoGrey),),

            Text(
              'filter by channel',
              
              textAlign: TextAlign.start,
              style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
            )
        ]),
      );
  }
}
