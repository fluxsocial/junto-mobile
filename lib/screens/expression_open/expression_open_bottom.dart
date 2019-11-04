import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/resonate_bottom_sheet.dart';

class ExpressionOpenBottom extends StatefulWidget {
  const ExpressionOpenBottom(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  State<StatefulWidget> createState() => ExpressionOpenBottomState();
}

class ExpressionOpenBottomState extends State<ExpressionOpenBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  // MaterialLocalizations.of(context).formatFullDate(
                  //   widget.expression.createdAt ?? DateTime.now(),
                  // ),
                  'today',
                  style: JuntoStyles.expressionTimestamp,
                ),
                // GestureDetector(
                //   onTap: () {
                //     _buildResonationModal();
                //   },
                //   child: Image.asset(
                //     'assets/images/junto-mobile__resonation.png',
                //     height: 17,
                //     color: const Color(0xff555555),
                //   ),
                // ),
              ]),
        ],
      ),
    );
  }

  void _buildResonationModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          child: ResonateBottomSheet(expression: widget.expression),
        );
      },
    );
  }
}
