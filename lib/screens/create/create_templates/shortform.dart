import 'package:flutter/material.dart';
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
  num gradientOne;
  num gradientTwo;

  String _currentBackground = 'zero';
  TextEditingController _bodyController;

  /// Creates a [CentralizedShortFormExpression] from the given data entered
  /// by the user.
  CentralizedShortFormExpression createExpression() {
    return CentralizedShortFormExpression(
      body: _bodyController.value.text,
      background: 'two',
    );
  }

  @override
  void initState() {
    super.initState();
    gradientOne = 0xff2c2cde;
    gradientTwo = 0xff7ec6e9;
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Widget _gradientSelector(String gradientId, num hexOne, num hexTwo) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gradientOne = hexOne;
          gradientTwo = hexTwo;
          _currentBackground = gradientId;
        });
      },
      child: Container(
        height: 38,
        width: 38,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.2, 0.9],
            colors: <Color>[Color(hexOne), Color(hexTwo)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: <Widget>[
                _gradientSelector('zero', 0xFF7461a1, 0xff285FA7),
                _gradientSelector('one', 0xff9e81d7, 0xffddcb7f),
                _gradientSelector('two', 0xff2c2cde, 0xff7ec6e9),
                _gradientSelector('three', 0xff719cf4, 0xffffc7e4),
                _gradientSelector('four', 0xff639acf, 0xff7bdaa5),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
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
                        0.2,
                        0.9,
                      ],
                      colors: <Color>[Color(gradientOne), Color(gradientTwo)],
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
