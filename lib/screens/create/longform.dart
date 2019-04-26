import 'package:flutter/material.dart';

import '../../typography/palette.dart';

class Longform extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        Column(children: [
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 20, bottom: 20),
        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
        // height: 90,
        width: 1000,
        // color: Colors.yellow,
        child: Text(
          'LONGFORM',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 17,
              color: JuntoPalette.juntoGrey,
              fontWeight: FontWeight.w700),
        ),
      ),
      Container(
        width: 1000,
        // color: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Title (optional)',
          ),
          cursorColor: JuntoPalette.juntoGrey,
          cursorWidth: 2,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
              color: JuntoPalette.juntoGrey),
          maxLines: 1,
          maxLength: 80,
        ),
      ),
      Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [

              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * .7,
                ),
                child: TextField(
                keyboardType: TextInputType.multiline,
                // textInputAction: TextInputAction,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                cursorColor: JuntoPalette.juntoGrey,
                cursorWidth: 2,                
                maxLines: null,
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: JuntoPalette.juntoGrey)),)
          ])),
          GestureDetector(
            onVerticalDragDown: (details) {
              FocusScope.of(context).requestFocus(new FocusNode());   

            },            
            // onTap: () {
            //   FocusScope.of(context).requestFocus(new FocusNode());   
            // },
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Color(0xffeeeeee), width: 1))),
              padding: EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.teal,
              height: 50,
              width: MediaQuery.of(context).size.width,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('# ADD CHANNELS',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                Text('CREATE',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))
              ]),
            ),
          )
    ]);
  }
}
