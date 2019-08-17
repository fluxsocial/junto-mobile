import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

class ExpressionOpenBottom extends StatefulWidget {
  final expression;

  ExpressionOpenBottom(this.expression);

  @override
  State<StatefulWidget> createState() {
    return ExpressionOpenBottomState();
  }
}

class ExpressionOpenBottomState extends State<ExpressionOpenBottom> {
  @override
  Widget build(BuildContext context) {
    String timestamp = widget.expression.timestamp; 

    return Container(
      margin: EdgeInsets.only(top: 7.5),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
        ),
ExpressionOpen
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(timestamp + ' MINUTES AGO', style: TextStyle(fontSize: 10, color: Color(0xff555555))),
              Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(CustomIcons.half_lotus, size: 14))
            ]),);
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[SizedBox()],
          ),
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(CustomIcons.half_lotus, size: 15))
        ],
      ),
    );

  }
}
