import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/models.dart';

/// Allows the user to create a short form expression.
class CreateShortform extends StatefulWidget {
  const CreateShortform({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateShortformState();
}

class CreateShortformState extends State<CreateShortform> {
  Color gradientOne;
  Color gradientTwo;

  // ignore: unused_field
  String _currentBackground = 'zero';
  TextEditingController _bodyController;

  /// Creates a [CentralizedShortFormExpression] from the given data entered
  /// by the user.
  CentralizedShortFormExpression createExpression() {
    return CentralizedShortFormExpression(
      body: _bodyController.value.text,
      background: _currentBackground,
    );
  }

  @override
  void initState() {
    super.initState();
    gradientOne = JuntoPalette.juntoPrimary;
    gradientTwo = JuntoPalette.juntoSecondary;
    _bodyController = TextEditingController();
  }


  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final String _bodyValue = _bodyController.text

    void _setBackground(String background) {
      if (background == 'zero') {
        setState(() {
          gradientOne = Colors.white;
          gradientTwo = Colors.white;
          _currentBackground = 'zero';
        });
      } else if (background == 'one') {
        setState(
          () {
            gradientOne = JuntoPalette.juntoSecondary;
            gradientTwo = JuntoPalette.juntoPrimary;
            _currentBackground = 'one';
          },
        );
      } else if (background == 'two') {
        setState(
          () {
            gradientOne = JuntoPalette.juntoSecondary;
            gradientTwo = JuntoPalette.juntoSecondaryLight;
            _currentBackground = 'two';
          },
        );
      } else if (background == 'three') {
        setState(() {
          gradientOne = JuntoPalette.juntoPrimary;
          gradientTwo = JuntoPalette.juntoPrimaryLight;
          _currentBackground = 'three';
        });
      } else if (background == 'four') {
        setState(
          () {
            gradientOne = JuntoPalette.juntoGreen;
            gradientTwo = JuntoPalette.juntoPrimary;
            _currentBackground = 'four';
          },
        );
      } else if (background == 'five') {
        setState(
          () {
            gradientOne = JuntoPalette.juntoGreen;
            gradientTwo = JuntoPalette.juntoSecondary;
            _currentBackground = 'five';
          },
        );
      }
    }

    Widget _buildBackgroundPicker(Color colorOne, Color colorTwo) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.1, 0.9],
            colors: <Color>[colorOne, colorTwo],
          ),
        ),
        margin: const EdgeInsets.only(right: 10),
        height: 36,
        width: 36,
      );
    }

    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _setBackground('one');
                        },
                        child: _buildBackgroundPicker(JuntoPalette.juntoPrimary,
                            JuntoPalette.juntoSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          _setBackground('two');
                        },
                        child: _buildBackgroundPicker(
                            JuntoPalette.juntoSecondaryLight,
                            JuntoPalette.juntoSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          _setBackground('three');
                        },
                        child: _buildBackgroundPicker(
                            JuntoPalette.juntoPrimaryLight,
                            JuntoPalette.juntoPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          _setBackground('four');
                        },
                        child: _buildBackgroundPicker(
                            JuntoPalette.juntoGreen, JuntoPalette.juntoPrimary),
                      ),
                      GestureDetector(
                        onTap: () {
                          _setBackground('five');
                        },
                        child: _buildBackgroundPicker(JuntoPalette.juntoGreen,
                            JuntoPalette.juntoSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: MediaQuery.of(context).size.height * .1),
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
                      hintText: 'gradients are fully customizeable and tbd',
                      hintMaxLines: 25,
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                    cursorWidth: 2,
                    maxLines: null,
                    style: const TextStyle(
                        color: Colors.white,
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
