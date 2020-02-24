import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class JuntoThemes extends StatelessWidget {
  Widget _themeSelector(BuildContext context, String theme) {
    return GestureDetector(
      onTap: () {
        Provider.of<JuntoThemesProvider>(context, listen: false)
            .setTheme(theme);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/junto-mobile__themes--' + theme + '.png',
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  theme.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text('Themes', style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(width: 42)
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: <Widget>[
                _themeSelector(context, 'rainbow'),
                _themeSelector(context, 'aqueous'),
                _themeSelector(context, 'royal'),
                _themeSelector(context, 'night'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
