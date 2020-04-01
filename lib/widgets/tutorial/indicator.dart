import 'package:flutter/material.dart';

class JuntoDescriptionIndicator extends StatelessWidget {
  JuntoDescriptionIndicator({this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}
