import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/app/styles.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: JuntoStyles.horizontalPadding,
        vertical: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          SizedBox(height: 5),
          Text(expressionBody,
              textAlign: TextAlign.left,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }

  Widget _buildTitle(context) {
    final String expressionTitle = expression.expressionData.title;
    if (expressionTitle != '') {
      return Container(
        child: Text(expressionTitle,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.title),
      );
    } else {
      return const SizedBox();
    }
  }
}
