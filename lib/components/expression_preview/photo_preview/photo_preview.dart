import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Displays the given [image] and [imageCaption]
class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    Key key,
    @required this.expression,
  }) : super(key: key);

  final Expression expression;

  // Widget _generateCaption() {
  //   if (imageCaption == '' || imageCaption == null) {
  //     return Container(height: 0, width: 0);
  //   } else {
  //     return Container(
  //       margin: const EdgeInsets.only(top: 10, left: 10),
  //       child: Text(
  //         imageCaption,
  //         maxLines: 2,
  //         textAlign: TextAlign.start,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(expression.expression.expressionContent['image'], fit: BoxFit.fitWidth),
        ),
        // _generateCaption()
      ],
    );
  }
}
