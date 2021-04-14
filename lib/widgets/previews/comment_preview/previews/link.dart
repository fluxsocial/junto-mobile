import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:embedly_preview/embedly_preview.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comment.expressionData.title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                comment.expressionData.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (comment.expressionData.caption.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: CustomParsedText(
                comment.expressionData.caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                defaultTextStyle: Theme.of(context).textTheme.caption,
                mentionTextStyle: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
            ),
          if (comment.expressionData.data != null)
            OEmbedWidget(
              data: comment.expressionData.data,
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
            )
          else
            Container(
              child: Text(
                comment.expressionData.url,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
