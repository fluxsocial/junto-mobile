import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class BackgroundTheme extends StatelessWidget {
  BackgroundTheme();

  String background(String themeName) {
    if (themeName == JuntoThemes().aqueous ||
        themeName == JuntoThemes().aqueousNight) {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (themeName == JuntoThemes().royal ||
        themeName == JuntoThemes().royalNight) {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (themeName == JuntoThemes().rainbow ||
        themeName == JuntoThemes().rainbowNight) {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            background(theme.themeName),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
