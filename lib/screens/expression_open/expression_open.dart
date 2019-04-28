import 'package:flutter/material.dart';

import '../../components/appbar/appbar_border/appbar_border.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart';
import '../../custom_icons.dart';
import '../../components/bottom_nav/bottom_nav.dart';
import './longform_open.dart';

class ExpressionOpen extends StatelessWidget {
  final expression;

  ExpressionOpen(this.expression);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _buildExpression() {
      if (expression.expressionType == 'longform') {
        return LongformOpen(expression);
      } else {
        return Container(child: Text('hellos'));
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(CustomIcons.back_arrow_left,
                    color: JuntoPalette.juntoSleek, size: 24),
              ),
              Icon(Icons.bookmark_border,
                  color: JuntoPalette.juntoSleek, size: 24)
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppbarBorder(JuntoPalette.juntoSleek),
            Expanded(
              child: ListView(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // profile picture
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            height: 36.0,
                            width: 36.0,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // profile name and handle
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Eric Yang',
                                style: TextStyle(
                                    color: JuntoPalette.juntoGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text('sunyata',
                                  style: TextStyle(
                                      color: JuntoPalette.juntoGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ]),
                ),
                _buildExpression(),

                Container(
                    margin: EdgeInsets.symmetric(vertical: 7.5),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xffeeeeee), width: 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text('#channel 1',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text('#channel 2',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text('#channel 3',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            Text('2 MINUTES AGO',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff555555)))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(CustomIcons.resonate),
                            ),
                            Icon(CustomIcons.comment)
                          ],
                        )
                      ],
                    )),

                // response

                // Column(
                //   children: <Widget>[
                //     Container(
                //       padding:
                //           EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //       child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: <Widget>[
                //             // profile picture
                //             ClipOval(
                //               child: Image.asset(
                //                 'assets/images/junto-mobile__eric.png',
                //                 height: 36.0,
                //                 width: 36.0,
                //                 fit: BoxFit.cover,
                //               ),
                //             ),

                //             // profile name and handle
                //             Container(
                //               margin: EdgeInsets.only(left: 10.0),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: <Widget>[
                //                   Text(
                //                     'Eric Yang',
                //                     style: TextStyle(
                //                         color: JuntoPalette.juntoGrey,
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w700),
                //                   ),
                //                   Text('sunyata',
                //                       style: TextStyle(
                //                           color: JuntoPalette.juntoGrey,
                //                           fontSize: 14,
                //                           fontWeight: FontWeight.w500))
                //                 ],
                //               ),
                //             ),
                //           ]),
                //     ),
                //     Container(
                //       padding: EdgeInsets.symmetric(horizontal: 10),
                //       child: Container(
                //         width: MediaQuery.of(context).size.width,
                //         child: Text(
                //           'This is a response',
                //           textAlign: TextAlign.start,
                //           style: TextStyle(fontSize: 17),
                //         ),
                //       ),
                //     )
                //   ],
                // )
              ]),
            ),

      Container(
        constraints: BoxConstraints(
          maxHeight: 250,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
        // color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xffeeeeee),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: EdgeInsets.only(left: 10, right: 10),
          // color: Color(0xffeeeeee),
          child: TextField(
              style: TextStyle(fontSize: 17),
              maxLines: null,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Reply to Eric')),
        ),
      ),            
          ],

          
        ),
      ),
      // bottomNavigationBar: 
      // Container(
      //   decoration: BoxDecoration(
      //       color: Colors.white,
      //       border:
      //           Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      //   // color: Colors.white,
      //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      //   child: Container(
      //     decoration: BoxDecoration(
      //         color: Color(0xffeeeeee),
      //         borderRadius: BorderRadius.all(Radius.circular(10))),
      //     padding: EdgeInsets.symmetric(horizontal: 10),
      //     // color: Color(0xffeeeeee),
      //     child: TextField(
      //         decoration: InputDecoration(
      //             border: InputBorder.none, hintText: 'Reply to Eric')),
      //   ),
      // ),
    );
  }
}
