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

    print(_expression.image);
    print(_expression.image.runtimeType);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          photoImage == 'test-image'
              ? const SizedBox()
              : Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                      tag: 'photo_preview-' + photoExpression.address,
                      child: Image.network(_expression.image,
                          height: 200, width: 200)
                      // Image.asset('assets/images/junto-mobile__mock--image.png',
                      //     fit: BoxFit.cover),
                      )
                  // child: Image.asset(photoImage, fit: BoxFit.fitWidth),
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
