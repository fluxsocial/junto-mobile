import 'package:flutter/material.dart';

import '../../typography/style.dart';
import '../../typography/palette.dart';
import '../../custom_icons.dart';

class GlobalSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GlobalSearchState();
  }
}

class GlobalSearchState extends State<GlobalSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(

            preferredSize: Size.fromHeight(45),
            child: AppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 0,
              title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(CustomIcons.back_arrow_left,
                                color: JuntoPalette.juntoSleek, size: 24),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Icon(Icons.search, size: 20)

                          )
                        ],
                      ),
                    ],
                  )),
            )),
        body: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))
                ),
                child: 
                  Row(
                    children: <Widget>[                      
                      Text('Members'),
                      SizedBox(width: 25),
                      Text('Spheres')
                    ],
                  ),                
              )                       
        ],));
        
        // ListView(
        //   children: <Widget>[],
        // ));
  }
}
