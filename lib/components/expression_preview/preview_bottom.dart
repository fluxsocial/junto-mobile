import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class PreviewBottom extends StatelessWidget {
  const PreviewBottom({Key key, this.expression}) : super(key: key);
  final Expression expression;

  @override
  Widget build(BuildContext context) {
    final String expressionTime = expression.timestamp;
    return Container(
      margin: const EdgeInsets.only(top: 7.5),
      padding:
          const EdgeInsets.symmetric(horizontal: JuntoStyles.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(expressionTime + ' MINUTES AGO',
                      textAlign: TextAlign.start,
                      style: JuntoStyles.expressionTimestamp),
                )
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(right: 10),
          //   child: const Icon(
          //     CustomIcons.half_lotus,
          //     size: 15,
          //     color: JuntoPalette.juntoPrimary,
          //   ),
          // )
        ],
      ),
    );
  }
}
