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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (expression.expressionData.title.isNotEmpty)
            Text("Title: ${expression.expressionData.title}"),
          OEmbedWidget(
            data: expression.expressionData.data,
            theme: EmbedlyThemeData(),
          ),
          if (expression.expressionData.caption.isNotEmpty)
            Text("Caption: ${expression.expressionData.caption}"),
        ],
      ),
    );
  }
}
