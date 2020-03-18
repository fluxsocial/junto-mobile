import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/expression_open/expression_open.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/action_items/expression_action_items.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/dynamic.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/event.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/photo.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview_types/shortform.dart';

/// Renders a concise overview of one given [ExpressionResult].
class TwoColumnExpressionPreview extends StatelessWidget with MemberValidation {
  const TwoColumnExpressionPreview({
    Key key,
    @required this.expression,
    @required this.userAddress,
  }) : super(key: key);

  final ExpressionResponse expression;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pending - create conditional statement that renders ExpressionOpenCreated if
        // the expression was created by the user. Otherwise display ExpressionOpen
        if (expression.type == 'PhotoForm') {
          Navigator.of(context).push(
            FadeRoute<void>(
              child: ExpressionOpen(
                expression,
                userAddress,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            PageRouteBuilder<ExpressionOpen>(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return ExpressionOpen(
                  expression,
                  userAddress,
                );
              },
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        }
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
                        expression.type != 'ShortForm'
                    ? Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(1),
                        width: .5)
                    : Border.all(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(9),
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => showUserDen(context, expression.creator),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .5 - 40,
                      ),
                      child: Text(
                        expression.creator.username.toLowerCase(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        builder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          child: ExpressionActionItems(
                            expression: expression,
                            userAddress: userAddress,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      width: 24,
                      child: Icon(
                        CustomIcons.morevertical,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                    ),
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
      return DynamicPreview(expression: expression);
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
