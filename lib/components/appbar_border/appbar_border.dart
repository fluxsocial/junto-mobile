
import 'package:flutter/material.dart';

class AppbarBorder extends StatelessWidget {
  final borderColor;

  AppbarBorder(this.borderColor);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: borderColor),
          ),
        ),
      );
  }
}