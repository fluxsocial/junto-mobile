import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

/// Takes an un-named [ExpressionResult] to be displayed
class ShortformPreview extends StatelessWidget {
  const ShortformPreview({
    @required this.comment,
  });

  /// [ExpressionResponse] to be displayed
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final String shortformBody = comment.expressionData.body.trim();
    final String _hexOne = comment.expressionData.background[0];
    final String _hexTwo = comment.expressionData.background[1];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.1, 0.9],
          colors: <Color>[HexColor.fromHex(_hexOne), HexColor.fromHex(_hexTwo)],
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width * (2 / 3),
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Text(
        shortformBody,
        maxLines: 5,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
