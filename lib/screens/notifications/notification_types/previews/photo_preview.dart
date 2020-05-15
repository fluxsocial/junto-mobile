import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

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
        child: ImageWrapper(
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
