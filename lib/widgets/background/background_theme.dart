import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes.dart';

class BackgroundTheme extends StatelessWidget {
  BackgroundTheme({this.currentTheme});

  final ThemeData currentTheme;

  String setBackground() {
    if (currentTheme == JuntoThemes().aqueous ||
        currentTheme == JuntoThemes().aqueousNight) {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (currentTheme == JuntoThemes().royal ||
        currentTheme == JuntoThemes().royalNight) {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (currentTheme == JuntoThemes().rainbow ||
        currentTheme == JuntoThemes().rainbowNight) {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        setBackground(),
        fit: BoxFit.cover,
      ),
    );
  }
}
