import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

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
            CustomParsedText(
              expression.expressionData.body,
              defaultTextStyle: TextStyle(
                height: 1.5,
                color: Theme.of(context).primaryColor,
                fontSize: 17,
              ),
              mentionTextStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 17,
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
