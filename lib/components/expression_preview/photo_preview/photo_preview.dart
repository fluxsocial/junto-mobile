import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/style.dart';

/// Displays the given [image] and [imageCaption]
class PhotoPreview extends StatelessWidget {
  const PhotoPreview(this.image, this.imageCaption);

  /// Url of the image to be displayed
  final String image;

  /// Image caption
  final String imageCaption;

  Widget _generateCaption() {
    if (imageCaption == '' || imageCaption == null) {
      return Container(height: 0, width: 0);
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10, left: 10),
        child: Text(
          imageCaption,
          maxLines: 2,
          textAlign: TextAlign.start,
          style: JuntoStyles.photoCaption,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Image.asset(image),
        ),
        _generateCaption()
      ],
    );
  }
}
