import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:feature_discovery/feature_discovery.dart';

class ExpressionOpenBottom extends StatelessWidget {
  const ExpressionOpenBottom(this.expression, this.openExpressionContext);

  final ExpressionResponse expression;
  final Function openExpressionContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .5,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
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
                        color: Theme.of(context).dividerColor,
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: openExpressionContext,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    color: Colors.transparent,
                    child: JuntoDescribedFeatureOverlay(
                      featureId: 'expression_context_id',
                      title: "View the channels this expression is tagged in.",
                      learnMore: false,
                      hasUpNext: false,
                      isLastFeature: true,
                      icon: Icon(
                        CustomIcons.newcreate,
                        size: 28,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Icon(
                        CustomIcons.newcreate,
                        size: 24,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
