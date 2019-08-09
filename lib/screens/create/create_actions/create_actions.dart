
import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../../../typography/style.dart';
import '../../../custom_icons.dart';

import './create_actions_appbar/create_actions_appbar.dart';


class CreateActions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateActionsState();
  }
}

class CreateActionsState extends State<CreateActions> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
      Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: CreateActionsAppbar()),
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1)))            ,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text('add channels')
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1)))            ,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text("sharing to 'collective'")
            ),            
          ],
        ));    
  }
}