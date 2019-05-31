
import 'package:flutter/material.dart';

class PerspectivePreview extends StatelessWidget {
  String title;
  PerspectivePreview(this.title);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        child: Text(title)
      );    
  }
}