import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

class NotificationSignal extends StatelessWidget {
  const NotificationSignal({
    this.top,
    this.right,
    this.onGradientBackground = false,
  });

  final double top;
  final double right;
  final bool onGradientBackground;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Positioned(
        top: top,
        right: right,
        child: Container(
          height: 7,
          width: 7,
          decoration: BoxDecoration(
            color: onGradientBackground
                ? JuntoPalette().juntoWhite(theme: theme)
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
    });
  }
}
