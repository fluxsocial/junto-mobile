import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class ExpressionPreviewBottom extends StatelessWidget {
  const ExpressionPreviewBottom({Key key, this.expression}) : super(key: key);
  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String expressionTime =
        MaterialLocalizations.of(context).formatFullDate(expression.createdAt);
    return Container(
        margin: const EdgeInsets.only(top: 7.5),
        padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding),
        child: Text(
          // expressionTime,
          'today',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.overline,
        ));
  }
}
