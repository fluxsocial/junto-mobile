
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';

class EventPreview extends StatelessWidget {
  final eventTitle;
  final eventLocation;
  final eventPhoto;

  EventPreview(this.eventTitle, this.eventLocation, this.eventPhoto);

  @override
  Widget build(BuildContext context) {

    return 
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .6,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
 
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(eventTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))
            ),
        
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(children: [
                Icon(Icons.location_searching, color: Color(0xff999999), size: 17),
                SizedBox(width: 5),
                Text(eventLocation, style: TextStyle(color: Color(0xff999999))) 
              ])
            ),          

            Container(
              child: Text('WED, JUN 19, 6:00PM', style: TextStyle(color: JuntoPalette.juntoBlue, fontSize: 12, fontWeight: FontWeight.w700))
            ),               

          ],),
          ),

          Container(
            width: MediaQuery.of(context).size.width * .25,
            child: Image.asset(eventPhoto)
          ),              

        ],)

      );     
  }
}