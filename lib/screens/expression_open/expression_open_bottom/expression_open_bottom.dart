import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class ExpressionOpenBottom extends StatefulWidget {
  const ExpressionOpenBottom(this.expression);

  final ExpressionResult expression;

  @override
  State<StatefulWidget> createState() => ExpressionOpenBottomState();
}

class ExpressionOpenBottomState extends State<ExpressionOpenBottom> {
  String timestamp;

  @override
  void initState() {
    super.initState();
    timestamp = widget.expression.result[0].timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 7.5),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xffeeeeee), width: .5),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    timestamp + ' MINUTES AGO',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(
                        0xff555555,
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Icon(CustomIcons.half_lotus, size: 14))
                ]),
          ],
        ));
  }
}
