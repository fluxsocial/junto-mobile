import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';

/// Allows the user to create a short form expression.
class CreateShortform extends StatefulWidget {
  const CreateShortform({
    Key key,
    @required this.isEditing,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;

  @override
  State<StatefulWidget> createState() => CreateShortformState();
}

class CreateShortformState extends State<CreateShortform> {
  Color gradientOne = Colors.white;
  Color gradientTwo = Colors.white;
  Color fontColor = JuntoPalette.juntoGrey;
  String _currentBackground = 'none';
  TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController();
    _bodyController.addListener(bodyListener);
  }

  void bodyListener() {
    if (_bodyController.value.text.isEmpty) {
      widget.isEditing.value = false;
    }
    if (_bodyController.value.text.isNotEmpty) {
      widget.isEditing.value = true;
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _bodyController.removeListener(bodyListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _bodyValue = _bodyController.text;

    //ignore:unused_local_variable
    final Map<String, dynamic> _shortformExpression = <String, dynamic>{
      'expression_type': 'ShortForm',
      'background': _currentBackground,
      'body': _bodyValue
    };

    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gradientOne = Colors.white;
                            gradientTwo = Colors.white;
                            fontColor = JuntoPalette.juntoGrey;
                            _currentBackground = 'none';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffeeeeee),
                              width: 1,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: <double>[0.1, 0.9],
                              colors: <Color>[
                                Colors.white,
                                Colors.white,
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          height: 36,
                          width: 36,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              gradientOne = JuntoPalette.juntoPrimary;
                              gradientTwo = JuntoPalette.juntoPrimaryLight;
                              fontColor = Colors.white;
                              _currentBackground = 'one';
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: <double>[0.1, 0.9],
                              colors: <Color>[
                                JuntoPalette.juntoPrimary,
                                JuntoPalette.juntoPrimaryLight
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            right: 1,
                          ),
                          height: 36,
                          width: 36,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              gradientOne = JuntoPalette.juntoSecondary;
                              gradientTwo = JuntoPalette.juntoSecondaryLight;
                              fontColor = Colors.white;
                              _currentBackground = 'two';
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: <double>[0.1, 0.9],
                              colors: <Color>[
                                JuntoPalette.juntoSecondary,
                                JuntoPalette.juntoSecondaryLight
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          height: 36,
                          width: 36,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gradientOne = JuntoPalette.juntoSecondary;
                            gradientTwo = JuntoPalette.juntoPrimary;
                            fontColor = Colors.white;
                            _currentBackground = 'three';
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: <double>[
                                  0.1,
                                  0.9
                                ],
                                colors: <Color>[
                                  JuntoPalette.juntoSecondary,
                                  JuntoPalette.juntoPrimary
                                ]),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          height: 36,
                          width: 36,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              gradientOne = JuntoPalette.juntoGreen;
                              gradientTwo = JuntoPalette.juntoPrimary;
                              fontColor = Colors.white;
                              _currentBackground = 'four';
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: <double>[
                                  0.1,
                                  0.9
                                ],
                                colors: <Color>[
                                  JuntoPalette.juntoGreen,
                                  JuntoPalette.juntoPrimary
                                ]),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          height: 36,
                          width: 36,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              gradientOne = JuntoPalette.juntoGreen;
                              gradientTwo = JuntoPalette.juntoSecondary;
                              fontColor = Colors.white;
                              _currentBackground = 'five';
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: <double>[
                                  0.1,
                                  0.9
                                ],
                                colors: <Color>[
                                  JuntoPalette.juntoGreen,
                                  JuntoPalette.juntoSecondary
                                ]),
                          ),
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          height: 36,
                          width: 36,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      stops: const <double>[
                        0.1,
                        0.9,
                      ],
                      colors: <Color>[gradientOne, gradientTwo],
                    ),
                  ),
                  child: TextField(
                    controller: _bodyController,
                    buildCounter: (
                      BuildContext context, {
                      int currentLength,
                      int maxLength,
                      bool isFocused,
                    }) =>
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
                    textInputAction: TextInputAction.done,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
