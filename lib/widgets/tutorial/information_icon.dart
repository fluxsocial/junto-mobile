import 'package:flutter/material.dart';

class JuntoInfoIcon extends StatelessWidget {
  JuntoInfoIcon({
    this.neutralBackground = true,
  });

  final bool neutralBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: !neutralBackground
              ? Colors.white
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 12,
            color: !neutralBackground
                ? Color(0xff555555)
                : Theme.of(context).backgroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
