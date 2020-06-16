import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    Key key,
    this.source,
    this.navigateTo,
    this.theme,
  }) : super(key: key);

  final ExpressionType source;
  final Function navigateTo;
  final JuntoThemesProvider theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (source == null || source == true) {
          Navigator.pop(context);
        } else {
          navigateTo(context, source);
        }
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        height: 50,
        width: 100,
        child: RotatedBox(
          quarterTurns: 2,
          child: Icon(
            CustomIcons.newdoubleuparrow,
            size: 45,
            color: JuntoPalette().juntoWhite(theme: theme),
          ),
        ),
      ),
    );
  }
}
