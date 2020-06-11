import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final ExpressionResponse photoExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: ImageWrapper(
              imageUrl: photoExpression.expressionData.image,
              placeholder: (BuildContext context, String _) {
                return Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dividerColor,
                  child: CachedNetworkImage(
                    imageUrl: photoExpression.thumbnailSmall,
                    fit: BoxFit.cover,
                    cacheManager: CustomCacheManager(),
                  ),
                );
              },
              fit: BoxFit.cover,
            ),
          ),
          if (photoExpression.expressionData.caption.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                photoExpression.expressionData.caption.trim(),
                style: Theme.of(context).textTheme.caption,
              ),
            )
        ],
      ),
    );
  }
}
