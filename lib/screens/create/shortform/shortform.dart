import 'package:flutter/material.dart';

import '../../../typography/palette.dart';
import '../create_actions.dart';

class CreateShortform extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateShortformState();
  }
}

class CreateShortformState extends State<CreateShortform> {
  var gradientOne = Colors.white;
  var gradientTwo = Colors.white;
  var fontColor = JuntoPalette.juntoGrey;

  Map _shortformExpression = {
      'expression': {
        'expression_type': 'shortform',
        'expression_data': {
          'ShortForm': {
            'background': 'none',
            'body': 'This is a shortform expression'
          }
        }                        
      },
      'tags': ['holochain', 'junto', 'social'],
      'context': ['dna']         
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: <Widget>[
        Expanded(
            child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = Colors.white;
                          gradientTwo = Colors.white;
                          fontColor = JuntoPalette.juntoGrey;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xffeeeeee), width: 1),
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0.1, 0.9],
                              colors: [Colors.white, Colors.white]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = JuntoPalette.juntoBlue;
                          gradientTwo = JuntoPalette.juntoBlueLight;
                          fontColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoBlue,
                                JuntoPalette.juntoBlueLight
                              ]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = JuntoPalette.juntoPurple;
                          gradientTwo = JuntoPalette.juntoPurpleLight;
                          fontColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoPurple,
                                JuntoPalette.juntoPurpleLight
                              ]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = JuntoPalette.juntoPurple;
                          gradientTwo = JuntoPalette.juntoBlue;
                          fontColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoPurple,
                                JuntoPalette.juntoBlue
                              ]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = JuntoPalette.juntoGreen;
                          gradientTwo = JuntoPalette.juntoBlue;
                          fontColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoGreen,
                                JuntoPalette.juntoBlue
                              ]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gradientOne = JuntoPalette.juntoGreen;
                          gradientTwo = JuntoPalette.juntoPurple;
                          fontColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoGreen,
                                JuntoPalette.juntoPurple
                              ]),
                        ),
                        margin: EdgeInsets.only(right: 10),
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: MediaQuery.of(context).size.height * .1225),
                height: MediaQuery.of(context).size.height * .40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.1, 0.9],
                        colors: [gradientOne, gradientTwo])),
                child: TextField(
                    buildCounter: (BuildContext context,
                            {int currentLength,
                            int maxLength,
                            bool isFocused}) =>
                        null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    cursorColor: fontColor,
                    cursorWidth: 2,
                    maxLines: null,
                    style: TextStyle(
                        color: fontColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                    maxLength: 220,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done))
          ],
        )),
        CreateActions(_shortformExpression)
      ],
    ));
  }
}
