import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
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
              : SizedBox(
                  width: double.maxFinite,
                  child: Hero(
                    tag: 'two_column_photo_preview-${photoExpression.address}',
                    child: ImageWrapper(
                      imageUrl: photoExpression.expressionData.image,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2.4,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).dividerColor,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          if (photoExpression.expressionData.caption.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                photoExpression.expressionData.caption,
                style: Theme.of(context).textTheme.caption,
              ),
            )
        ],
      ),
    );
  }
}
