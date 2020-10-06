import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';

class ShortformOpen extends StatelessWidget {
  const ShortformOpen(this.expression);

  final Comment expression;

  @override
  Widget build(BuildContext context) {
    final String _hexOne = expression.expressionData.background[0];
    final String _hexTwo = expression.expressionData.background[1];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.1, 0.9],
          colors: <Color>[
            HexColor.fromHex(_hexOne),
            HexColor.fromHex(_hexTwo),
          ],
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width * (2 / 3),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 50.0,
      ),
      child: CustomParsedText(
        expression.expressionData.body.trim(),
        maxLines: 7,
        overflow: TextOverflow.ellipsis,
        defaultTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
        ),
        mentionTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
