import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:embedly_preview/embedly_preview.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                expression.expressionData.caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.5,
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          OEmbedWidget(
            data: expression.expressionData.data,
            theme: EmbedlyThemeData(
              brightness: Theme.of(context).brightness,
              backgroundColor: Theme.of(context).backgroundColor,
              headingText: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
              subheadingText: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
              elevation: 0.0,
            ),
            // theme: EmbedlyThemeData(),
          ),
        ],
      ),
    );
  }
}
