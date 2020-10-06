import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:provider/provider.dart';

// Displays the given [image] and [imageCaption]
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: ImageWrapper(
            imageUrl: comment.expressionData.thumbnail600,
            placeholder: (BuildContext context, String _) {
              return Container(
                color: Theme.of(context).dividerColor,
                height: MediaQuery.of(context).size.width / 3 * 2,
                width: MediaQuery.of(context).size.width,
              );
            },
            fit: BoxFit.cover,
          ),
        ),
        if (comment.expressionData.caption.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: ParsedText(
              text: comment.expressionData.caption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
              parse: [
                MatchText(
                  pattern: r"\[(@[^:]+):([^\]]+)\]",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
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
      ],
    );
  }
}
