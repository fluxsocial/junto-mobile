import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

/// Allows the user to create a short form expression.
class CreateShortform extends StatefulWidget {
  const CreateShortform({Key key, this.expressionContext, this.address})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => CreateShortformState();
}

class CreateShortformState extends State<CreateShortform> {
  final FocusNode _focus = FocusNode();
  bool _showBottomNav = true;
  String gradientOne;
  String gradientTwo;

  TextEditingController _bodyController;

  void toggleBottomNav() {
    setState(() {
      _showBottomNav = !_showBottomNav;
    });
  }

  /// Creates a [ShortFormExpression] from the given data entered
  /// by the user.
  ShortFormExpression createExpression() {
    return ShortFormExpression(
      body: _bodyController.value.text.trim(),
      background: <dynamic>[gradientOne, gradientTwo],
    );
  }

  bool validate() {
    return _bodyController.value.text != null &&
        _bodyController.value.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    gradientOne = '8E8098';
    gradientTwo = '307FAA';
    _bodyController = TextEditingController();
    _focus.addListener(toggleBottomNav);
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Widget _gradientSelector(String hexOne, String hexTwo) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gradientOne = hexOne;
          gradientTwo = hexTwo;
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
            colors: <Color>[
              HexColor.fromHex(hexOne),
              HexColor.fromHex(hexTwo),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() {
    if (validate() == true) {
      final ShortFormExpression expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return CreateActions(
              expressionType: ExpressionType.shortform,
              address: widget.address,
              expressionContext: widget.expressionContext,
              expression: expression,
            );
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: "Please make sure the text field isn't blank",
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      expressionType: ExpressionType.shortform,
      onNext: _onNext,
      showBottomNav: _showBottomNav,
      child: Expanded(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: 58,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _gradientSelector('fbfbfb', 'fff4e6'),
                  _gradientSelector('222222', '555555'),
                  _gradientSelector('2E4F78', '6397C7'),
                  _gradientSelector('2034BC', 'BD96D6'),
                  _gradientSelector('6F51A8', 'E8B974'),
                  _gradientSelector('719cf4', 'ffc7e4'),
                  _gradientSelector('639acf', '7bdaa5'),
                  _gradientSelector('E7E26E', '2CBAB1'),
                  _gradientSelector('FC6073', 'FFD391'),
                ],
              ),
            ),
            Expanded(
              child: Form(
                autovalidate: false,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50.0,
                        horizontal: 25.0,
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.width,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const <double>[
                            0.2,
                            0.9,
                          ],
                          colors: <Color>[
                            HexColor.fromHex(gradientOne),
                            HexColor.fromHex(gradientTwo),
                          ],
                        ),
                      ),
                      child: TextField(
                        focusNode: _focus,
                        autofocus: false,
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
                        cursorColor: gradientOne.contains('fff') ||
                                gradientTwo.contains('fff')
                            ? Color(0xff333333)
                            : Colors.white,
                        cursorWidth: 2,
                        maxLines: null,
                        style: TextStyle(
                          color: gradientOne.contains('fff') ||
                                  gradientTwo.contains('fff')
                              ? Color(0xff333333)
                              : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLength: 220,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        keyboardAppearance: Theme.of(context).brightness,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
