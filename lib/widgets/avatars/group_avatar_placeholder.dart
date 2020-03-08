import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class GroupAvatarPlaceholder extends StatelessWidget {
  const GroupAvatarPlaceholder({this.diameter});

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
      child: Icon(
        CustomIcons.spheres,
        color: Colors.white,
        size: diameter / 3,
      ),
    );
  }
}
