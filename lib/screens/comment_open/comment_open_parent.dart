import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';

class CommentOpenParent extends StatelessWidget {
  const CommentOpenParent({
    this.comment,
  });
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Text(
        'in response to ${comment.creator.name}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColorLight,
          fontSize: 14,
        ),
      ),
    );
  }
}
