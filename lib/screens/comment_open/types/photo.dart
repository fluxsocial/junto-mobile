import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:junto_beta_mobile/widgets/photo/interactive_image_viewer_overlay.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final Comment photoExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InteractiveImageViewerOverlay(
            maxScale: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ImageWrapper(
                imageUrl: photoExpression.expressionData.image,
                placeholder: (BuildContext context, String _) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).dividerColor,
                    child: CachedNetworkImage(
                      imageUrl: photoExpression.expressionData.thumbnail600,
                      fit: BoxFit.cover,
                      cacheManager: CustomCacheManager.instance,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (photoExpression.expressionData.caption.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomParsedText(
                photoExpression.expressionData.caption,
                defaultTextStyle: Theme.of(context).textTheme.caption,
                mentionTextStyle: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
            )
        ],
      ),
    );
  }
}
