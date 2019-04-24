import 'package:flutter/material.dart';

import '../../typography/style.dart';

class PhotoPreview extends StatelessWidget {
  final image;
  PhotoPreview(this.image);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(child: Image.asset(image)),
        Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Text(
                'Hello my name is Urk. This marks the collaboratin between Junto and Holochain. Stay tuned.',
                maxLines: 2,
                textAlign: TextAlign.start,
                style: JuntoStyles.photoCaption),),
      ],
    );
  }
}
