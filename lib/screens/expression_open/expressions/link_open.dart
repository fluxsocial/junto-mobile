import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:embedly_preview/embedly_preview.dart';
import 'package:embedly_preview/theme/embedly_theme_data.dart';
import 'package:embedly_preview/theme/theme.dart';

class LinkOpen extends StatelessWidget {
  const LinkOpen(this.expression);

  final ExpressionResponse expression;

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
              child: SelectableText(
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
              child: CustomParsedText(
                expression.expressionData.caption,
                defaultTextStyle: TextStyle(
                  height: 1.5,
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                ),
                mentionTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(expression.expressionData.url)) {
                await launch(expression.expressionData.url);
              }
            },
            child: Column(
              children: [
                if (expression.expressionData.data != null)
                  OEmbedWidget(
                    data: expression.expressionData.data,
                    expanded: true,
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
                    child: SelectableText(
                      expression.expressionData.url,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
