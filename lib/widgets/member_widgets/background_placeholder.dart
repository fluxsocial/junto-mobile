import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class MemberBackgroundPlaceholder extends StatelessWidget {
  const MemberBackgroundPlaceholder();

  String background(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (theme == 'dark' || theme == 'dark-night') {
      return 'assets/images/junto-mobile__themes--dark.png';
    } else if (theme == 'sand' || theme == 'sand-night') {
      return 'assets/images/junto-mobile__themes--sand.png';
    } else if (theme == 'fire' || theme == 'fire-night') {
      return 'assets/images/junto-mobile__themes--fire.png';
    } else if (theme == 'forest' || theme == 'forest-night') {
      return 'assets/images/junto-mobile__themes--forest.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          background(theme.themeName),
          height: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      );
    });
  }
}
