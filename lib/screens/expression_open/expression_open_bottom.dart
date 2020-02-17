import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';

class ExpressionOpenBottom extends StatelessWidget {
  const ExpressionOpenBottom(this.expression, this.openExpressionContext);

  final CentralizedExpressionResponse expression;
  final Function openExpressionContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        parseDate(
                          context,
                          expression.createdAt,
                        ).toLowerCase(),
                        style: JuntoStyles.expressionTimestamp,
                      ),
                    ]),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor, width: .5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: openExpressionContext,
                  child: Container(
                    height: 33,
                    width: 33,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(CustomIcons.create,
                        size: 15, color: Theme.of(context).primaryColorLight),
                  ),
                )

                // Container(
                //   color: Colors.transparent,
                //   height: 33,
                //   width: 33,
                //   child: Icon(CustomIcons.comment,
                //       size: 15, color: Theme.of(context).primaryColorLight),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
