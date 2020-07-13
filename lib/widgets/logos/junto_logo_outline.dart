import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class JuntoLogoOutline extends StatelessWidget {
  const JuntoLogoOutline({
    Key key,
  }) : super(key: key);

  String logo(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__logo-outline--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__logo-outline--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__logo-outline--purpgold.png';
    } else if (theme == 'dark') {
      return 'assets/images/junto-mobile__logo-outline--dark.png';
    } else if (theme == 'dark-night') {
      return 'assets/images/junto-mobile__logo-outline--white.png';
    } else if (theme == 'sand' || theme == 'sand-night') {
      return 'assets/images/junto-mobile__logo-outline--sand.png';
    } else if (theme == 'fire' || theme == 'fire-night') {
      return 'assets/images/junto-mobile__logo-outline--fire.png';
    } else if (theme == 'forest' || theme == 'forest-night') {
      return 'assets/images/junto-mobile__logo-outline--forest.png';
    } else {
      return 'assets/images/junto-mobile__logo-outline--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Image.asset(
          logo(theme.themeName),
          height: 60,
        ),
      );
    });
  }
}
