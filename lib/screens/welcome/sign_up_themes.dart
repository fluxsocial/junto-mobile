import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

class SignUpThemes extends StatelessWidget {
  const SignUpThemes({
    Key key,
  }) : super(key: key);

  void _setTheme(String theme, BuildContext context) {
    switch (theme) {
      case 'RAINBOW':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('rainbow');
        break;
      case 'AQUEOUS':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('aqueous');
        break;

      case 'PURPLE GOLD':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('royal');
        break;

      case 'FIRE':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('fire');
        break;

      case 'FOREST':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('forest');
        break;

      case 'SAND':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('sand');
        break;

      case 'DARK':
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme('dark');
        break;
    }
  }

  Widget _displayThemeSelector(
      String themeName, JuntoThemesProvider theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _setTheme(themeName, context);
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(
          right: 32,
          left: 32,
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  _displayThemeAsset(themeName),
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              themeName,
              style: TextStyle(
                color: JuntoPalette().juntoWhite(theme: theme),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayThemeAsset(String theme) {
    switch (theme) {
      case 'RAINBOW':
        return 'assets/images/junto-mobile__themes--rainbow.png';
        break;
      case 'AQUEOUS':
        return 'assets/images/junto-mobile__themes--aqueous.png';
        break;

      case 'PURPLE GOLD':
        return 'assets/images/junto-mobile__themes--royal.png';
        break;

      case 'FIRE':
        return 'assets/images/junto-mobile__themes--fire.png';
        break;

      case 'FOREST':
        return 'assets/images/junto-mobile__themes--forest.png';
        break;

      case 'SAND':
        return 'assets/images/junto-mobile__themes--sand.png';
        break;

      case 'DARK':
        return 'assets/images/junto-mobile__themes--dark.png';
        break;
    }
    return 'assets/images/junto-mobile__themes--rainbow.png';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .24),
              Container(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _displayThemeSelector('RAINBOW', theme, context),
                    _displayThemeSelector('AQUEOUS', theme, context),
                    _displayThemeSelector('PURPLE GOLD', theme, context),
                    _displayThemeSelector('FIRE', theme, context),
                    _displayThemeSelector('FOREST', theme, context),
                    _displayThemeSelector('SAND', theme, context),
                    _displayThemeSelector('DARK', theme, context),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
