import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

class DynamicPreview extends StatelessWidget {
  const DynamicPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildTitle(context), _buildBody(context)],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final String expressionTitle = expression.expressionData.title.trim();
    if (expressionTitle.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Text(
          expressionTitle,
          textAlign: TextAlign.left,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBody(BuildContext context) {
    final String expressionBody = expression.expressionData.body.trim();
    if (expressionBody.isNotEmpty) {
      return ParsedText(
        text: expressionBody,
        maxLines: 7,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: 1.5,
          color: Theme.of(context).primaryColor,
          fontSize: 17,
        ),
        parse: [
          MatchText(
            pattern: r"\[(@[^:]+):([^\]]+)\]",
            style: TextStyle(
              color: Colors.green,
              fontSize: 17,
              height: 1.5,
            ),
            renderText: ({String str, String pattern}) {
              Map<String, String> map = <String, String>{};
              RegExp customRegExp = RegExp(pattern);
              Match match = customRegExp.firstMatch(str);
              map['display'] = match.group(1);
              map['value'] = match.group(2);
              return map;
            },
            onTap: (url) {},
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
