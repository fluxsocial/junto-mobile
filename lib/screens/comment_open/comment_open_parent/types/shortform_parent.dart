import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class ShortformParent extends StatelessWidget {
  ShortformParent({this.expression});
  final dynamic expression;
  @override
  Widget build(BuildContext context) {
    final String _body = expression.expressionData.body;

    final String _hexOne = expression.expressionData.background[0];

    final String _hexTwo = expression.expressionData.background[1];

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width / 2,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: Text(
        _body,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
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
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
