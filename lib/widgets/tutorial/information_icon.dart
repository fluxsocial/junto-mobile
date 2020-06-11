import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';

class JuntoInfoIcon extends StatelessWidget {
  JuntoInfoIcon({
    this.neutralBackground = true,
    this.theme,
  });

  final bool neutralBackground;
  final JuntoThemesProvider theme;

  Color _fillColor(BuildContext context) {
    if (neutralBackground) {
      return Theme.of(context).primaryColor;
    } else if (theme.themeName.contains('sand') && !neutralBackground) {
      return Color(0xff555555);
    } else if (!neutralBackground) {
      return Colors.white;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  Color _textColor(BuildContext context) {
    if (neutralBackground) {
      return Theme.of(context).backgroundColor;
    } else if (theme.themeName.contains('sand') && !neutralBackground) {
      return Colors.white;
    } else if (!neutralBackground) {
      return Color(0xff555555);
    } else {
      return Theme.of(context).backgroundColor;
    }
  }

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
          color: _fillColor(context),
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 12,
            color: _textColor(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
