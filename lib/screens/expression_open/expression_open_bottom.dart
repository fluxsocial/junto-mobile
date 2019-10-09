import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/palette.dart';

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
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
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
                  MaterialLocalizations.of(context).formatFullDate(
                    widget.expression.createdAt ?? DateTime.now(),
                  ),
                  style: const TextStyle(
                      fontSize: 10, color: JuntoPalette.juntoSleek),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/junto-mobile__resonation.png',
                      height: 17,
                      color: const Color(0xff999999),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Resonate',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff999999),
                      ),
                    )
                  ],
                )
              ]),
        ],
      ),
    );
  }
}
