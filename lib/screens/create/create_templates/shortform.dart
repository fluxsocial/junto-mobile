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
  final String _currentBackground = '';
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
    return Expanded(
      child: Column(
        children: <Widget>[
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
                      hintText: 'will soon be custom gradient picker...',
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
