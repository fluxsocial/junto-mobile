import 'package:flutter/material.dart';

class OverlayInfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 50,
      child: Text(
        '?',
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
