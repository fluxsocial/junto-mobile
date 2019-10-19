import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class JuntoPerspectives extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoPerspectivesState();
  }
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
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
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 33,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xff4263A3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search, size: 17, color: Colors.white),
                              const SizedBox(width: 5),
                              Transform.translate(
                                offset: const Offset(0.0, 2.5),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .72 -
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
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            GestureDetector(
                              onTap: () {
                                _createPerspectiveBottomSheet();
                              },
                              child: Container(
                                  height: 38,
                                  width: 38,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.add,
                                      color: Colors.white, size: 17)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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

  _buildPerspective(String name, String members) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          left:
                              BorderSide(color: Color(0xffeeeeee), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                        const SizedBox(height: 5),
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

  _createPerspectiveBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => Container(
        color: const Color(0xff737373),
        child: Container(
          height: MediaQuery.of(context).size.height * .9,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  // Text('cancel'),
                  Text(
                    'New Perspective',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff333333),
                    ),
                  ),
                  Text(
                    'create',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
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
                      hintText: 'Name your perspective',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff999999),
                      )),
                  cursorColor: const Color(0xff333333),
                  cursorWidth: 2,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Color(0xff333333),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  maxLength: 80,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffeeeeee),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 20,
                      color: const Color(0xff999999),
                    ),
                    const SizedBox(width: 5),
                    Transform.translate(
                      offset: Offset(
                        0.0,
                        5,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
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
                              hintText: 'Add members',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff999999),
                              )),
                          cursorColor: const Color(0xff333333),
                          cursorWidth: 2,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          maxLength: 80,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
