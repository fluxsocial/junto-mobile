import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final CentralizedExpressionResponse photoExpression;

  @override
  Widget build(BuildContext context) {
    final CentralizedPhotoFormExpression _expression =
        photoExpression.expressionData as CentralizedPhotoFormExpression;
    final String photoImage = _expression.image;
    final String photoCaption = _expression.caption;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          photoImage == 'test-image'
              ? const SizedBox()
              : Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/' + photoImage,
                      fit: BoxFit.fitWidth),
                ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              photoCaption,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
