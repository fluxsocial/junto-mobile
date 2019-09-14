import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/components/expression_preview/longform_preview/longform_preview.dart';
import 'package:junto_beta_mobile/components/expression_preview/preview_bottom.dart';
import 'package:junto_beta_mobile/components/expression_preview/preview_profile.dart';
import 'package:junto_beta_mobile/components/expression_preview/shortform_preview/shortform_preview.dart';
import 'package:junto_beta_mobile/components/expression_preview/photo_preview/photo_preview.dart';
import 'package:junto_beta_mobile/components/expression_preview/event_preview/event_preview.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';

/// Renders a concise overview of one given [ExpressionResult].
class ExpressionPreview extends StatelessWidget {
  const ExpressionPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final Expression expression;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute<dynamic>(
              builder: (BuildContext context) => ExpressionOpen(expression),
            ),
          );
        },
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // expression preview profile
              PreviewProfile(expression: expression),

              // expression preview body
              _returnExpression(),

              // expression preview channels, resonation, and comments
              PreviewBottom(expression: expression)
            ],
          ),
        ));
  }

  Widget _returnExpression() {
    if (expression.expression.expressionType == 'longform') {
      return LongformPreview(expression: expression);
    } else if (expression.expression.expressionType == 'shortform') {
      return ShortformPreview(expression);
    } else if (expression.expression.expressionType == 'photo') {
      return PhotoPreview(expression: expression);
    } else if (expression.expression.expressionType == 'event') {
      return EventPreview(expression: expression);
    } else {
      return Container();
    }
  }
}
