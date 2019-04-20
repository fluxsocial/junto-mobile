
import 'package:flutter/material.dart';

// typography
import '../../../typography/palette.dart';

class FilterPacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
      Container(
        alignment: Alignment.center,
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 17.0),
        width: 1000,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
          ),
        ),
        child: 
          TextField(
            cursorColor: JuntoPalette.juntoGrey,
            cursorWidth: 1.0,
            decoration: InputDecoration(
              icon: Icon(Icons.search, size: 14.0, color: JuntoPalette.juntoGrey),            
              border: InputBorder.none,
              hintText: 'search packs',
              hintStyle: TextStyle(color: JuntoPalette.juntoGrey, fontSize: 14.0)
            
            ),
          )
      );
          
  }
}