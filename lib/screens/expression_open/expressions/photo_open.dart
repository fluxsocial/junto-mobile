import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final CentralizedExpressionResponse photoExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          photoExpression.expressionData.image == 'test-image'
              ? const SizedBox()
              : Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: 'photo_preview-' + photoExpression.address,
                    child: CachedNetworkImage(
                        imageUrl: photoExpression.expressionData.image,
                        placeholder: (BuildContext context, String _) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: const <double>[0.2, 0.9],
                                colors: <Color>[
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).colorScheme.primary
                                ],
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              photoExpression.expressionData.caption,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
