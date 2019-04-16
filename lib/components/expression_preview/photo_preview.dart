
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  final image;
  PhotoPreview(this.image);
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        child: Image.asset(image)
      );     
  }
}