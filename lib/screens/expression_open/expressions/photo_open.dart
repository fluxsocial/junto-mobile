import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/widgets/photo/interactive_image_viewer_overlay.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final ExpressionResponse photoExpression;

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
                        imageUrl: photoExpression.thumbnailSmall,
                        fit: BoxFit.cover,
                        cacheManager: CustomCacheManager.instance,
                        placeholder: (BuildContext context, String _) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          );
                        }),
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
                photoExpression.expressionData.caption.trim(),
                defaultTextStyle: Theme.of(context).textTheme.caption,
                mentionTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
        ],
      ),
    );
  }
}
