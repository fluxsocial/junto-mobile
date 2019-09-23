import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final Expression photoExpression;

  @override
  Widget build(BuildContext context) {
    final String photoImage =
        photoExpression.expression.expressionContent['image'];
    final String photoCaption =
        photoExpression.expression.expressionContent['caption'];

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(photoImage, fit: BoxFit.fitWidth),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              photoCaption,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
