import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Displays the given [image] and [imageCaption]
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: 'photo_preview-' + expression.address,
            child: Image.asset('assets/images/junto-mobile__mock--image.png',
                fit: BoxFit.cover),
          )
          // child: expression.expressionData.image == '' ? SizedBox() : Image.asset(expression.expressionData.image, fit: BoxFit.cover),
          ),
    );
  }
}
