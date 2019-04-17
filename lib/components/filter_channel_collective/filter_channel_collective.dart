
import 'package:flutter/material.dart';

import './../../theme.dart';

class FilterChannelCollective extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return 
      // filter by channel
      Container(
        padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 17.0),
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

                Icon(Icons.search),

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
