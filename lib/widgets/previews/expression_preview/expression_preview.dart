import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/event_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/longform_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/photo_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview_types/shortform_preview.dart';

/// Renders a concise overview of one given [ExpressionResult].
class ExpressionPreview extends StatelessWidget {
  ExpressionPreview({Key key, @required this.expression}) : super(key: key);

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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border:
                    Border.all(color: Theme.of(context).dividerColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // expression preview body
                  _returnExpression(),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // expression preview handle + more action items
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<dynamic>(
                          builder: (
                            BuildContext context,
                          ) =>
                              JuntoMember(profile: expression.creator),
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              expression.creator.username.toLowerCase(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              color: Colors.transparent,
                              child: ExpressionActionItems(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            CustomIcons.morevertical,
                            color: Theme.of(context).primaryColor,
                            size: 17,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _returnExpression() {
    if (expression.type == 'LongForm') {
      return LongformPreview(expression: expression);
    } else if (expression.type == 'ShortForm') {
      return ShortformPreview(expression: expression);
    } else if (expression.type == 'PhotoForm') {
      return PhotoPreview(expression: expression);
    } else if (expression.type == 'EventForm') {
      return EventPreview(expression: expression);
    } else {
      return Container();
    }
  }
}
