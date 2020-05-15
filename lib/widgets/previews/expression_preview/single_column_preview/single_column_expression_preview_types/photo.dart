import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

// Displays the given [image] and [imageCaption]
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ImageWrapper(
        imageUrl: expression.expressionData.image,
        placeholder: (BuildContext context, String _) {
          return Container(
            color: Theme.of(context).dividerColor,
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
