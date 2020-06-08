import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/models/models.dart';

class PhotoParent extends StatelessWidget {
  const PhotoParent({this.expression});
  final ExpressionResponse expression;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: MediaQuery.of(context).size.width / 3 * 2,
        width: MediaQuery.of(context).size.width,
        child: ImageWrapper(
          imageUrl: expression.expressionData.image,
          placeholder: (BuildContext context, String _) {
            return Container(
              color: Theme.of(context).dividerColor,
              height: MediaQuery.of(context).size.width / 3 * 2,
              width: MediaQuery.of(context).size.width,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
