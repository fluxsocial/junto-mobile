import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class LongformPreview extends StatelessWidget {
  const LongformPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String expressionBody = expression.expressionData.body;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          Text(
            expressionBody,
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            // style: Theme.of(context).textTheme.caption,
            style: TextStyle(
              height: 1.7,
              color: Theme.of(context).primaryColorDark,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final String expressionTitle = expression.expressionData.title;
    if (expressionTitle.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Text(
          expressionTitle,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.title,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
