import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class LongformPreview extends StatelessWidget {
  const LongformPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildTitle(context), _buildBody(context)],
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
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBody(BuildContext context) {
    final String expressionBody = expression.expressionData.body;
    if (expressionBody.isNotEmpty) {
      return Text(
        expressionBody,
        maxLines: 7,
        overflow: TextOverflow.ellipsis,
        // style: Theme.of(context).textTheme.caption,
        style: TextStyle(
          height: 1.5,
          color: Theme.of(context).primaryColor,
          fontSize: 15,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
