import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/themes.dart';
import 'package:provider/provider.dart';

class BackgroundTheme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BackgroundThemeState();
  }
}

class BackgroundThemeState extends State<BackgroundTheme> {
  ThemeData _currentTheme;
  String backgroundImageAsset;
  @override
  void initState() {
    super.initState();
    _getTheme();
  }

  Future<void> _getTheme() async {
    final theme = await Provider.of<JuntoThemesProvider>(context, listen: false)
        .getTheme();
    setState(() {
      _currentTheme = theme;
    });
  }

  String setBackground() {
    setState(
      () {
        if (_currentTheme == JuntoThemes().aqueous ||
            _currentTheme == JuntoThemes().aqueousNight) {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--aqueous.png';
        } else if (_currentTheme == JuntoThemes().royal ||
            _currentTheme == JuntoThemes().royalNight) {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--royal.png';
        } else if (_currentTheme == JuntoThemes().rainbow ||
            _currentTheme == JuntoThemes().rainbowNight) {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--rainbow.png';
        } else {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--rainbow.png';
        }
      },
    );
    return backgroundImageAsset;
  }

  String returnImageAsset() {
    return backgroundImageAsset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        setBackground(),
        fit: BoxFit.cover,
      ),
    );
  }
}
