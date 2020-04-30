import 'package:flutter/material.dart';

class AudioButtonDecoration extends StatelessWidget {
  const AudioButtonDecoration({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Theme.of(context).backgroundColor,
          width: 5,
        ),
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 9,
            spreadRadius: 3,
          )
        ],
      ),
      child: child,
    );
  }
}
