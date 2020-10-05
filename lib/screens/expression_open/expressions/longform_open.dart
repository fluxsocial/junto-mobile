import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/link_text.dart';
import 'package:provider/provider.dart';

class LongformOpen extends StatelessWidget {
  const LongformOpen(this.longformExpression);

  final ExpressionResponse longformExpression;

  @override
  Widget build(BuildContext context) {
    final LongFormExpression _expression =
        longformExpression.expressionData as LongFormExpression;

    final String longformTitle = _expression.title.trim();
    final String longformBody = _expression.body.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          longformTitle != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: SelectableText(
                    longformTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : const SizedBox(),
          longformBody != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ParsedText(
                    text: longformBody,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w500,
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
                          final userData = await Provider.of<UserRepo>(context,
                                  listen: false)
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
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
