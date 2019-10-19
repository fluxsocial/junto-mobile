import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class JuntoPerspectives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return JuntoPerspectivesState();
  }
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: <double>[0.1, 0.9],
              colors: <Color>[
                JuntoPalette.juntoSecondary,
                JuntoPalette.juntoPrimary,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xff4263A3),
                        width: .75,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/junto-mobile__logo--white.png',
                          height: 22.0, width: 22.0),
                      SizedBox(width: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * .72,
                        alignment: Alignment.centerLeft,
                        height: 33,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff4263A3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search, size: 17, color: Colors.white),
                            SizedBox(width: 5),
                            Transform.translate(
                              offset: Offset(0.0, 2.5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .72 -
                                    45,
                                child: TextField(
                                  buildCounter: (
                                    BuildContext context, {
                                    int currentLength,
                                    int maxLength,
                                    bool isFocused,
                                  }) =>
                                      null,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: Colors.white,
                                  cursorWidth: 2,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  maxLength: 80,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'PERSPECTIVES',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            Icon(Icons.add, color: Colors.white, size: 17)
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildPerspective('JUNTO', 'all'),
                      _buildPerspective('Connections', '99'),
                      _buildPerspective('Subscriptions', '220'),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  _buildPerspective(name, members) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                // padding: EdgeInsets.only(left: 15),
                // decoration: BoxDecoration(
                //   border: Border(
                //     left: BorderSide(color: Color(0xffeeeeee), width: 1.5),
                //   ),
                // ),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          left:
                              BorderSide(color: Color(0xffeeeeee), width: 1.5),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 1.2,
                              color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          members + ' members',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              letterSpacing: 1.2,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white)
        ],
      ),
    );
  }
}
