
import 'package:flutter/material.dart';

import './../../../typography/palette.dart';

class CreateBullet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateBulletState();
  }
}

class CreateBulletState extends State<CreateBullet> {

  List _bullets = [];
  var id = 1;

  // Function to add Bullet
  void _addBullet(bullet) {
    setState(() {
      id += 1;
      _bullets.add(bullet);
    });
  }

  // Function to remove bullet
  void _removeBullet() {
    setState(() {
      id -= 1;
      _bullets.removeLast();
    });
  }

  // Return the widget that calls _removeBullet()
  _removeBulletWidget() {
    return 
      GestureDetector(
        onTap: () {
          _removeBullet();
        },
        child: Icon(Icons.remove_circle_outline)
      );          
  }

  // Initiate the first bullet
  @override
  void initState() {
    Map bullet = {
      'key': id 
    };

    _addBullet(bullet); 
    super.initState();
  }
  
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

              GestureDetector(
                onTap: () {
                  Map bullet = {
                    'key': id 
                  };              
                  _addBullet(bullet);
                  print(_bullets);
                },
                child: Icon(Icons.add_circle_outline)
              )
            ],),
      ),
      Container(
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: _bullets.map((bullet) =>       
            Container(
              margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xffdddddd), width: 1)
                ),
                height: 200,
                width: MediaQuery.of(context).size.width - 20,
                child: 
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              bullet['key'].toString() +'/' + _bullets.length.toString(),
                              style: TextStyle(color: Color(0xff333333))
                            ),
                            bullet['key'] > 1 ? _removeBulletWidget() : Container()
                        ],),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 20),
                      child: 
                        TextField(
                          buildCounter: (BuildContext context,
                                  {int currentLength, int maxLength, bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          cursorColor: JuntoPalette.juntoGrey,
                          cursorWidth: 2,
                          maxLines: null,
                          maxLength: 220,
                          textInputAction: TextInputAction.done,
                        ),
                    )

                  ])
            )).toList(),
          ))
    ]);
  }
}
