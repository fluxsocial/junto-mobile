
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';

class CreateEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        children: <Widget>[
          Container(
            child: 
            TextField(
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name of event',
              ),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              style: JuntoStyles.lotusLongformTitle,
              maxLines: 1,
              maxLength: 80,
            ),                   
          ), 

          // Container(
          //   color: Color(0xfffbfbfb),
          //   height: 200,
          //   width: MediaQuery.of(context).size.width,
          //   child: Center(child: Text('Add a cover photo (optional)'))
          // ), 

          Container(
            child: 
            TextField(
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Date and Time',
              ),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              style: JuntoStyles.lotusLongformTitle,
              maxLines: 1,
              maxLength: 80,
            ),                   
          ),

          Container(
            child: 
            TextField(
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name of event',
              ),
              cursorColor: JuntoPalette.juntoGrey,
              cursorWidth: 2,
              style: JuntoStyles.lotusLongformTitle,
              maxLines: 1,
              maxLength: 80,
            ),                   
          ),

          Container(
            constraints: BoxConstraints(minHeight: 100, maxHeight: 240),
            padding: EdgeInsets.only(bottom: 40),            
            child: TextField(
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Details',
                ),
                cursorColor: JuntoPalette.juntoGrey,
                cursorWidth: 2,
                style: JuntoStyles.lotusLongformTitle,
                maxLines: null,
                textInputAction: TextInputAction.newline,
              ),                
          )                    
   

      ],)
    );
  }
}