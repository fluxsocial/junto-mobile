import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/expression_open/expressions/richtext.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

class CreateLongformReview extends StatelessWidget {
  const CreateLongformReview({this.expression});
  final dynamic expression;

  @override
  Widget build(BuildContext context) {
    final String longformTitle = expression.title;
    final String longformBody = expression.body;

    List<dynamic> richtext;

    try {
      richtext = jsonDecode(longformBody);
    } catch (error) {
      print('test: $error');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          if (longformTitle.isNotEmpty)
            Container(
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
            ),
          if (richtext == null)
            longformBody != ''
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomParsedText(
                      longformBody,
                      defaultTextStyle: TextStyle(
                        height: 1.5,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                      mentionTextStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 17,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : const SizedBox()
          else
            Richtext(
              data: richtext,
              disableOnMentiontap: true,
            ),
        ],
      ),
    );
  }
}
