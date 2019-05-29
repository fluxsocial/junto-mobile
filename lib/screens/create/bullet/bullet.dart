
import 'package:flutter/material.dart';

import './../../../typography/palette.dart';

class CreateBullet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateBulletState();
  }
}

class CreateBulletState extends State<CreateBullet> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 300,
                child:    
                TextField(
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title (optional)',
                  ),
                  cursorColor: JuntoPalette.juntoGrey,
                  cursorWidth: 2,
                  maxLines: 1,
                  maxLength: 80,
                  
                ),
              ),

              Icon(Icons.add_circle_outline)
            ],),
      ),
      Container(
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff333333), width: 1)
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width - 20,
              ),

              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff333333), width: 1)
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width - 20,
              ),              
            ],
          ))
    ]);
  }
}
