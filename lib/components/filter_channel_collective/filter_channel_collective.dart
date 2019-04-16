
import 'package:flutter/material.dart';

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
            bottom: BorderSide(width: .75, color: Colors.grey),
          ),
        ),
        child: Row(children: [
          IconButton(
            onPressed: () {},
            color: Colors.blue,
            alignment: Alignment(-1.0, 0),
            icon: Icon(Icons.search),
            padding: EdgeInsets.all(0.0),
          ),

          Text(
            'filter by channel',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
          )
        ]),
      );
  }
}