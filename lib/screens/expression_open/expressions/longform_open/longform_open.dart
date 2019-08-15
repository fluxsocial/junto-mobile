import 'package:flutter/material.dart';

class LongformOpen extends StatelessWidget {
  final longformExpression;

  LongformOpen(this.longformExpression);

  @override
  Widget build(BuildContext context) {
    String longformTitle =
        longformExpression.expression['entry']['expression']['title'];
    String longformBody =
        longformExpression.expression['entry']['expression']['body'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5),
            child: Text(
              longformTitle,
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
            child: Text(
              longformBody,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}
