
import 'package:flutter/material.dart';

class PerspectivePreview extends StatelessWidget {
  String title;
  PerspectivePreview(this.title);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Icon(Icons.edit, size: 12)
          ])
      );    
  }
}