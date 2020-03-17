import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

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
      child: Hero(
        tag: 'single_column_photo_preview-' + expression.address,
        child: RepaintBoundary(
          child: CachedNetworkImage(
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
        ),
      ),
    );
  }
}
