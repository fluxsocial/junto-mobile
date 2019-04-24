
import 'package:flutter/material.dart';

import './channel_preview.dart';
import '../../custom_icons.dart';

class PreviewBottom extends StatelessWidget {
  final String time;

  PreviewBottom(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7.5),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(

           child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ChannelPreview(),
                    ChannelPreview(),
                    ChannelPreview(),
                  ]),
                 Container(
                   margin: EdgeInsets.only(top: 2.5),
                   child: Text(time + ' MINUTES AGO', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600), textAlign: TextAlign.start,)

                 ) 
              ],
            )

          ),
          
          Container(
            alignment: Alignment.center,
            child: Row(children: [
              Icon(CustomIcons.resonate, size: 22, color: Colors.black),
              Container(
                margin: EdgeInsets.only(left: 17),
                child: Icon(CustomIcons.comment, size: 22, color: Colors.black)
              ),

            ])
          )


        ],
      ),
    );
  }
}
