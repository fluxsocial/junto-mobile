import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/action_items/expression_action_items.dart';

class ExpressionPreviewBottom extends StatelessWidget with MemberValidation {
  const ExpressionPreviewBottom({this.expression});

  final expression;

  @override
  Widget build(BuildContext context) {
    return
        // expression preview handle + more action items
        Container(
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
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
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
                    deleteExpression: (expression) {
                      //TODO(Nash): Remove expression
                    },
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(
                left: 10,
                top: 7.5,
                bottom: 7.5,
              ),
              child: Icon(
                CustomIcons.morevertical,
                color: Theme.of(context).primaryColor,
                size: 17,
              ),
            ),
          )
        ],
      ),
    );
  }
}
