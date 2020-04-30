import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class AudioButtonBackground extends StatelessWidget {
  String background(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return ClipOval(
        child: Container(
          height: 80,
          width: 80,
          child: Image.asset(
            background(theme.themeName),
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
