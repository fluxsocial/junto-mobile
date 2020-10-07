import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:provider/provider.dart';

class CustomParsedText extends StatelessWidget {
  final TextStyle defaultTextStyle;
  final TextStyle mentionTextStyle;
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign alignment;
  final bool disableOnMentiontap;

  const CustomParsedText(
    this.text, {
    Key key,
    this.defaultTextStyle,
    this.mentionTextStyle,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.alignment = TextAlign.start,
    this.disableOnMentiontap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      text: text.trim(),
      maxLines: maxLines,
      overflow: overflow,
      alignment: alignment,
      style: defaultTextStyle,
      parse: [
        MatchText(
          pattern: r"\[(@[^:]+):([^\]]+)\]",
          style: mentionTextStyle,
          renderText: ({String str, String pattern}) {
            Map<String, String> map = <String, String>{};
            RegExp customRegExp = RegExp(pattern);
            Match match = customRegExp.firstMatch(str);
            map['display'] = match.group(1);
            map['value'] = match.group(2);
            return map;
          },
          onTap: (url) async {
            if (!disableOnMentiontap) {
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
            }
          },
        ),
      ],
    );
  }
}