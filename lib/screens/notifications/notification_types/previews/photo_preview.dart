import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';

class NotificationPhotoPreview extends StatelessWidget {
  const NotificationPhotoPreview({this.item});

  final JuntoNotification item;
  @override
  Widget build(BuildContext context) {
    final ExpressionSlimModel sourceExpression = item.sourceExpression;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: MediaQuery.of(context).size.width / 3 * 2 - 68,
        width: MediaQuery.of(context).size.width - 68,
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager(),
          imageUrl: sourceExpression.expressionData['image'],
          placeholder: (BuildContext context, String _) {
            return Container(
              color: Theme.of(context).dividerColor,
              height: MediaQuery.of(context).size.width / 3 * 2 - 68,
              width: MediaQuery.of(context).size.width - 68,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
