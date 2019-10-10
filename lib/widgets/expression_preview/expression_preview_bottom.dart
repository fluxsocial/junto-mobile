import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/styles.dart';

class ExpressionPreviewBottom extends StatelessWidget {
  const ExpressionPreviewBottom({Key key, this.expression}) : super(key: key);
  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String expressionTime =
        MaterialLocalizations.of(context).formatFullDate(expression.createdAt);
    return Container(
      margin: const EdgeInsets.only(top: 7.5),
      padding:
          const EdgeInsets.symmetric(horizontal: JuntoStyles.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    expressionTime,
                    textAlign: TextAlign.start,
                    style: JuntoStyles.expressionTimestamp,
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
