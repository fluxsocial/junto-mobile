import 'package:flutter/material.dart';

class MemberAvatarPlaceholder extends StatelessWidget {
  const MemberAvatarPlaceholder({this.diameter});

  final double diameter;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[
            0.3,
            0.9,
          ],
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        'assets/images/junto-mobile__logo--white.png',
        height: diameter / 3,
      ),
    );
  }
}
