import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open_created.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/event_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/longform_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/photo_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_bottom.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_top.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/shortform_preview.dart';

/// Renders a concise overview of one given [ExpressionResult].
class ExpressionPreview extends StatelessWidget {
  const ExpressionPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pending - create conditional statement that renders ExpressionOpenCreated if
        // the expression was created by the user. Otherwise display ExpressionOpen
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => ExpressionOpen(expression),
          ),
        );

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute<dynamic>(
        //     builder: (BuildContext context) => ExpressionOpenCreated(expression),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(bottom: 5),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // expression preview profile
            ExpressionPreviewTop(expression: expression),

            // expression preview body
            _returnExpression(),

            // expression preview channels, resonation, and comments
            ExpressionPreviewBottom(expression: expression)
          ],
        ),
      ),
    );
  }

  Widget _returnExpression() {
    if (expression.type == 'LongForm') {
      return LongformPreview(expression: expression);
    } else if (expression.type == 'ShortForm') {
      return ShortformPreview(expression);
    } else if (expression.type == 'PhotoForm') {
      return PhotoPreview(expression: expression);
    } else if (expression.type == 'EventForm') {
      return EventPreview(expression: expression);
    } else {
      return Container();
    }
  }
}
