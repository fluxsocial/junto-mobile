import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class DynamicOpen extends StatelessWidget {
  const DynamicOpen(this.dynamicExpression);

  final Comment dynamicExpression;

  @override
  Widget build(BuildContext context) {
    final LongFormExpression _expression =
        dynamicExpression.expressionData as LongFormExpression;

    final String dynamicTitle = _expression.title.trim();
    final String dynamicBody = _expression.body.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          dynamicTitle != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: SelectableText(
                    dynamicTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : const SizedBox(),
          dynamicBody != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: SelectableText(
                    dynamicBody,
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
