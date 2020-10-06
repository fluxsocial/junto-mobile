import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:embedly_preview/embedly_preview.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';
import 'package:embedly_preview/theme/theme.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:provider/provider.dart';

class LinkOpen extends StatelessWidget {
  const LinkOpen(this.expression);

  final Comment expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expression.expressionData.title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                expression.expressionData.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (expression.expressionData.caption.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: ParsedText(
                text: expression.expressionData.caption,
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
            ),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(expression.expressionData.url)) {
                await launch(expression.expressionData.url);
              }
            },
            child: OEmbedWidget(
              data: expression.expressionData.data,
              expanded: false,
              theme: EmbedlyThemeData(
                brightness: Theme.of(context).brightness,
                backgroundColor: Theme.of(context).backgroundColor,
                headingText: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
                subheadingText: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
                elevation: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
