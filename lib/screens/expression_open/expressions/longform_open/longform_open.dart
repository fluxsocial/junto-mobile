import 'package:flutter/material.dart';

class LongformOpen extends StatelessWidget {
  final longformExpression;

  LongformOpen(this.longformExpression);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              longformExpression.expression['expression_data']['LongForm']['title'],
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.1),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Text(longformExpression.expression['expression_data']['LongForm']['body'],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15, height: 1.2)))
        ],
      ),
    );
  }
}
