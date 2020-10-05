import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final ExpressionResponse photoExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: ImageWrapper(
              imageUrl: photoExpression.expressionData.image,
              placeholder: (BuildContext context, String _) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dividerColor,
                  child: CachedNetworkImage(
                      imageUrl: photoExpression.thumbnailSmall,
                      fit: BoxFit.cover,
                      cacheManager: CustomCacheManager(),
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          color: Theme.of(context).dividerColor,
                        );
                      }),
                );
              },
              fit: BoxFit.cover,
            ),
          ),
          if (photoExpression.expressionData.caption.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ParsedText(
                text: photoExpression.expressionData.caption.trim(),
                style: Theme.of(context).textTheme.caption,
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
                    onTap: (url) {},
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
