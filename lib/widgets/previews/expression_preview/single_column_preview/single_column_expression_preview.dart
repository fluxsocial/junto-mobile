import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_bottom.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/audio.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/dynamic.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/event.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/photo.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/shortform.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview_types/link.dart';

/// Renders a concise overview of one given [ExpressionResult].
class SingleColumnExpressionPreview extends StatelessWidget
    with MemberValidation {
  const SingleColumnExpressionPreview({
    Key key,
    @required this.deleteExpression,
    @required this.expression,
  }) : super(key: key);

  final ExpressionResponse expression;
  final ValueChanged<ExpressionResponse> deleteExpression;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pending - create conditional statement that renders ExpressionOpenCreated if
        // the expression was created by the user. Otherwise display ExpressionOpen
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ExpressionOpen(
              deleteExpression,
              expression,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: expression.type != 'PhotoForm' &&
                        expression.type != 'ShortForm' &&
                        expression.type != 'AudioForm'
                    ? Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .5,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: .5,
                        ),
                      )
                    : Border.all(width: 0, color: Colors.transparent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // expression preview body
                  _returnExpression(),
                ],
              ),
            ),

            // expression preview handle + more action items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ExpressionPreviewBottom(
                expression: expression,
                deleteExpression: deleteExpression,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _returnExpression() {
    if (expression.type == 'LongForm') {
      return DynamicPreview(expression: expression);
    } else if (expression.type == 'ShortForm') {
      return ShortformPreview(expression: expression);
    } else if (expression.type == 'PhotoForm') {
      return PhotoPreview(expression: expression);
    } else if (expression.type == 'EventForm') {
      return EventPreview(expression: expression);
    } else if (expression.type == 'AudioForm') {
      return AudioPreview(expression: expression);
    } else if (expression.type == 'LinkForm') {
      return LinkPreview(expression: expression);
    } else {
      return Container();
    }
  }
}
