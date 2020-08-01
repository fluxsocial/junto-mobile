import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/link_text.dart';

class LongformOpen extends StatelessWidget {
  const LongformOpen(this.longformExpression);

  final ExpressionResponse longformExpression;

  @override
  Widget build(BuildContext context) {
    final LongFormExpression _expression =
        longformExpression.expressionData as LongFormExpression;

    final String longformTitle = _expression.title.trim();
    final String longformBody = _expression.body.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          longformTitle != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: SelectableText(
                    longformTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : const SizedBox(),
          longformBody != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: LinkText(
                    longformBody,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
