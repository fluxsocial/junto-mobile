import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';

class NotificationShortformPreview extends StatelessWidget {
  const NotificationShortformPreview({this.item});

  final JuntoNotification item;
  @override
  Widget build(BuildContext context) {
    final ExpressionSlimModel sourceExpression = item.sourceExpression;
    final String _hexOne =
        item.sourceExpression.expressionData['background'][0];

    final String _hexTwo =
        item.sourceExpression.expressionData['background'][1];

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.width / 3 * 2 - 68,
      ),
      width: MediaQuery.of(context).size.width - 68,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: Text(
        sourceExpression.expressionData['body'],
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
