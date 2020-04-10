import 'package:flutter/material.dart';

class OverlayInfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '?',
        style: TextStyle(
          fontSize: 17,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
