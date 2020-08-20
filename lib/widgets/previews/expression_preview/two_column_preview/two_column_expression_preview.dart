import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_bottom.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/dynamic.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/event.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/photo.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/shortform.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/link.dart';

import 'two_column_expression_preview_types/audio.dart';

/// Renders a concise overview of one given [ExpressionResult].
class TwoColumnExpressionPreview extends StatelessWidget with MemberValidation {
  const TwoColumnExpressionPreview({
    Key key,
    @required this.expression,
    @required this.deleteExpression,
  }) : super(key: key);

  final ExpressionResponse expression;
  final ValueChanged<ExpressionResponse> deleteExpression;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
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
                      ? Border.all(
                          color: Theme.of(context).dividerColor,
                          width: .5,
                        )
                      : Border.all(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (expression.type == 'ShortForm')
                      ShortformPreview(expression: expression)
                    else if (expression.type == 'PhotoForm')
                      PhotoPreview(expression: expression)
                    else if (expression.type == 'EventForm')
                      EventPreview(expression: expression)
                    else if (expression.type == 'AudioForm')
                      AudioPreview(expression: expression)
                    else if (expression.type == 'LongForm')
                      DynamicPreview(expression: expression)
                    else if (expression.type == 'LinkForm')
                      LinkPreview(expression: expression)
                    else
                      SizedBox()
                  ],
                ),
              ),

              // expression preview handle + more action items
              ExpressionPreviewBottom(
                expression: expression,
                deleteExpression: deleteExpression,
              )
            ],
          ),
        ),
      ),
    );
  }
}
