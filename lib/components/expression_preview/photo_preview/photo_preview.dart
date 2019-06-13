import 'package:flutter/material.dart';

import '../../../typography/style.dart';

class PhotoPreview extends StatelessWidget {
  final image;
  final imageCaption; 

  PhotoPreview(this.image, this.imageCaption);

  _generateCaption() {
    if(imageCaption == '' || imageCaption == null) {
      return Container(
        height: 0,
        width: 0
      );
    } else {
      return 
        Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          child: Text(
              imageCaption,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: JuntoStyles.photoCaption),
        );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(child: Image.asset(image)),
        _generateCaption()
      ],
    );
  }
}
