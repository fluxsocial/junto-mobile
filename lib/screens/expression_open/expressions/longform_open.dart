import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class LongformOpen extends StatelessWidget {
  const LongformOpen(this.longformExpression);

  final Expression longformExpression;

  @override
  Widget build(BuildContext context) {
    final String longformTitle =
        longformExpression.expression.expressionContent['title'];
    final String longformBody =
        longformExpression.expression.expressionContent['body'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              longformTitle,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.1),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              longformBody,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 17, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
