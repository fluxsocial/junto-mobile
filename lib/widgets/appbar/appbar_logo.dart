
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';

class AppbarLogo extends StatelessWidget {
  const AppbarLogo({this.theme});

  final JuntoThemesProvider theme;
  String logo(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__logo--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__logo--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__logo--purpgold.png';
    } else if (theme == 'fire' || theme == 'fire-night') {
      return 'assets/images/junto-mobile__logo--fire.png';
    } else if (theme == 'forest' || theme == 'forest-night') {
      return 'assets/images/junto-mobile__logo--forest.png';
    } else if (theme == 'sand' || theme == 'sand-night') {
      return 'assets/images/junto-mobile__logo--sand.png';
    } else if (theme == 'dark') {
      return 'assets/images/junto-mobile__logo--dark.png';
    } else if (theme == 'dark-night') {
      return 'assets/images/junto-mobile__logo--white.png';
    } else {
      return 'assets/images/junto-mobile__logo--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logo(theme.themeName),
      height: 24.0,
      width: 24.0,
    );
  }
}
