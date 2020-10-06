import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:provider/provider.dart';

class DynamicOpen extends StatelessWidget {
  const DynamicOpen(this.dynamicExpression);

  final Comment dynamicExpression;

  @override
  Widget build(BuildContext context) {
    final LongFormExpression _expression =
        dynamicExpression.expressionData as LongFormExpression;

    final String dynamicTitle = _expression.title.trim();
    final String dynamicBody = _expression.body.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (dynamicTitle.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 5),
              child: SelectableText(
                dynamicTitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          if (dynamicBody.isNotEmpty)
            ParsedText(
              text: dynamicBody,
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
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                  renderText: ({String str, String pattern}) {
                    Map<String, String> map = <String, String>{};
                    RegExp customRegExp = RegExp(pattern);
                    Match match = customRegExp.firstMatch(str);
                    map['display'] = match.group(1);
                    map['value'] = match.group(2);
                    return map;
                  },
                  onTap: (url) async {
                    final userData =
                        await Provider.of<UserRepo>(context, listen: false)
                            .getUser(url);

                    Navigator.push(
                      context,
                      CupertinoPageRoute<Widget>(
                        builder: (BuildContext context) => JuntoMember(
                          profile: userData.user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
