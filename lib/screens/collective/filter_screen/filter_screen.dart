import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/filter_fab/filter_fab.dart';
import 'package:junto_beta_mobile/typography/palette.dart';


class CollectiveFilterScreen extends StatelessWidget {
  final isVisible;
  final toggleFilter;
  CollectiveFilterScreen(this.isVisible, this.toggleFilter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        bottomNavigationBar: Container(color: Colors.white, height: 45),
        floatingActionButton: CollectiveFilterFAB(isVisible, toggleFilter),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 45),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffeeeeee), width: 1))),
                      child: TextField(
                        buildCounter: (BuildContext context,
                                {int currentLength,
                                int maxLength,
                                bool isFocused}) =>
                            null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'filter by channel',
                        ),
                        cursorColor: JuntoPalette.juntoGrey,
                        cursorWidth: 2,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff333333)),
                        maxLines: 1,
                        maxLength: 80,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
