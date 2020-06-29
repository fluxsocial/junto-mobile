import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicParent extends StatelessWidget {
  DynamicParent({this.expression});

  final dynamic expression;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .75,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (expression.expressionData.title.isNotEmpty)
            Text(
              expression.expressionData.title,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),

          // add space if title and body are both not empty
          if (expression.expressionData.title.isNotEmpty &&
              expression.expressionData.body.isNotEmpty)
            const SizedBox(height: 10),

          if (expression.expressionData.body.isNotEmpty)
            Text(
              expression.expressionData.body,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
