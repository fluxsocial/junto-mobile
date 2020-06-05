import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class SignUpThemes extends StatelessWidget {
  const SignUpThemes({
    Key key,
  }) : super(key: key);

  void _setTheme(String theme, BuildContext context) {
    if (theme == 'AQUEOUS') {
      Provider.of<JuntoThemesProvider>(context, listen: false)
          .setTheme('aqueous');
    } else if (theme == 'PURPLE GOLD') {
      Provider.of<JuntoThemesProvider>(context, listen: false)
          .setTheme('royal');
    } else if (theme == 'RAINBOW') {
      Provider.of<JuntoThemesProvider>(context, listen: false)
          .setTheme('rainbow');
    }
  }

  Widget _displayThemeSelector(String theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _setTheme(theme, context);
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
                  _displayThemeAsset(theme),
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              theme,
              style: const TextStyle(
                color: Colors.white,
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
    if (theme == 'AQUEOUS') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (theme == 'PURPLE GOLD') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (theme == 'NIGHT') {
      return 'assets/images/junto-mobile__themes--dark.png';
    } else if (theme == 'RAINBOW') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
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
                  _displayThemeSelector('RAINBOW', context),
                  _displayThemeSelector('AQUEOUS', context),
                  _displayThemeSelector('PURPLE GOLD', context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
