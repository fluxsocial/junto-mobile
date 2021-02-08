import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

/// Allows the user to create a short form expression.
class CreateShortformReview extends StatelessWidget {
  const CreateShortformReview({this.expression});
  final dynamic expression;

  @override
  Widget build(BuildContext context) {
    final String _hexOne =
        expression.background.isNotEmpty ? expression.background[0] : '333333';
    final String _hexTwo =
        expression.background.isNotEmpty ? expression.background[1] : '222222';
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
        expression.body.trim(),
        alignment: TextAlign.center,
        defaultTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
        ),
        mentionTextStyle: TextStyle(
          color: _hexOne.contains('fff') || _hexTwo.contains('fff')
              ? Color(0xff333333)
              : Colors.white,
          fontSize: 20,
          height: 1.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
