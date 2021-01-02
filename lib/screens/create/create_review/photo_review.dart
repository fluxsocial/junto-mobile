import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

/// Create using photo form
class CreatePhotoReview extends StatelessWidget {
  const CreatePhotoReview({this.expression});
  final dynamic expression;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: Image.file(expression['image'])),
        if (expression['caption'].trim().isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomParsedText(
              expression['caption'].trim(),
              defaultTextStyle: Theme.of(context).textTheme.caption,
              mentionTextStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 17,
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
      ],
    );
  }
}
