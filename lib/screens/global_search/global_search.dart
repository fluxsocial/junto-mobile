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
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(CustomIcons.back_arrow_left,
                          color: JuntoPalette.juntoSleek, size: 24),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Transform.translate(
                        offset: Offset(0, 7),
                        child: TextField(
                          buildCounter: (BuildContext context,
                                  {int currentLength,
                                  int maxLength,
                                  bool isFocused}) =>
                              null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'search..',
                          ),
                          cursorColor: JuntoPalette.juntoGrey,
                          maxLines: 1,
                          maxLength: 30,
                          cursorWidth: 2,
                        ),
                      ),
                    ),
                  ],
                ))),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
              child: Row(
                children: <Widget>[
                  Text('Members'),
                  SizedBox(width: 25),
                  Text('Spheres')
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[],
              ),
            )
          ],
        ));
  }
}
