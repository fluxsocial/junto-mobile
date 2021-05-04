import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';

class DynamicPreview extends StatelessWidget {
  const DynamicPreview({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final String commentTitle = comment.expressionData.title.trim();
    if (commentTitle.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Text(
          commentTitle,
          textAlign: TextAlign.left,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBody(BuildContext context) {
    final String commentBody = comment.expressionData.body.trim();
    if (commentBody.isNotEmpty) {
      return CustomParsedText(
        commentBody,
        overflow: TextOverflow.ellipsis,
        defaultTextStyle: Theme.of(context).textTheme.caption,
        mentionTextStyle: Theme.of(context).textTheme.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorDark,
            ),
      );
    } else {
      return const SizedBox();
    }
  }
}
