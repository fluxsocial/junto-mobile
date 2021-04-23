import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateLinkFormReview extends StatelessWidget {
  const CreateLinkFormReview({this.expression});

  final LinkFormExpression expression;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expression.title.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: SelectableText(
                expression.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (expression.caption.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: CustomParsedText(
                expression.caption,
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
              if (await canLaunch(expression.url)) {
                await launch(expression.url);
              }
            },
            child: Container(
              child: SelectableText(
                expression.url,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
