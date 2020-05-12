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
          photoExpression.expressionData.image == 'test-image'
              ? const SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: 'photo_preview-${photoExpression.address}',
                    child: ImageWrapper(
                      imageUrl: photoExpression.expressionData.image,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).dividerColor,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          photoExpression.expressionData.caption != ''
              ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    photoExpression.expressionData.caption,
                    style: Theme.of(context).textTheme.caption,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
