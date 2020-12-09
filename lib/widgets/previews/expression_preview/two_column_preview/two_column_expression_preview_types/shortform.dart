import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

/// Takes an un-named [ExpressionResult] to be displayed
class ShortformPreview extends StatelessWidget {
  const ShortformPreview({
    @required this.expression,
  });

  /// [ExpressionResponse] to be displayed
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String shortformBody = expression.expressionData.body;
    final String _hexOne = expression.expressionData.background.isNotEmpty
        ? expression.expressionData.background[0]
        : '333333';
    final String _hexTwo = expression.expressionData.background.isNotEmpty
        ? expression.expressionData.background[1]
        : '222222';

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.1, 0.9],
            colors: <Color>[
              HexColor.fromHex(_hexOne),
              HexColor.fromHex(_hexTwo)
            ],
          ),
        ),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * .24,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: CustomParsedText(
          shortformBody,
          maxLines: 7,
          disableOnMentiontap: true,
          alignment: TextAlign.center,
          defaultTextStyle: TextStyle(
            fontSize: 18,
            color: _hexOne.contains('fff') || _hexTwo.contains('fff')
                ? Color(0xff333333)
                : Colors.white,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
          mentionTextStyle: TextStyle(
            color: _hexOne.contains('fff') || _hexTwo.contains('fff')
                ? Color(0xff333333)
                : Colors.white,
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
