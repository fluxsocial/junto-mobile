import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:junto_beta_mobile/widgets/link_text.dart';

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
    final String _hexOne = expression.expressionData.background[0];
    final String _hexTwo = expression.expressionData.background[1];

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
        // width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
        child: ParsedText(
          text: shortformBody,
          maxLines: 7,
          alignment: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: _hexOne.contains('fff') || _hexTwo.contains('fff')
                ? Color(0xff333333)
                : Colors.white,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
          parse: [
            MatchText(
              pattern: r"\[(@[^:]+):([^\]]+)\]",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 17,
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
              renderText: ({String str, String pattern}) {
                Map<String, String> map = <String, String>{};
                RegExp customRegExp = RegExp(pattern);
                Match match = customRegExp.firstMatch(str);
                map['display'] = match.group(1);
                map['value'] = match.group(2);
                return map;
              },
              onTap: (url) {},
            ),
          ],
        ),
      ),
    );
  }
}
