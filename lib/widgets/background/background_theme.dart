import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class BackgroundTheme extends StatelessWidget {
  String background(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (theme == 'dark' || theme == 'dark-night') {
      return 'assets/images/junto-mobile__themes--night.png';
    } else if (theme == 'sand' || theme == 'sand-night') {
      return 'assets/images/junto-mobile__themes--sand.png';
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
            // background(theme.themeName),
            'assets/images/junto-mobile__themes--night.png',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
