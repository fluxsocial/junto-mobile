
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  var image;
  PhotoPreview(this.image);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
      Container(
        child: Image.asset(image)
      );     
  }
}