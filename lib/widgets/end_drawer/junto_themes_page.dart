import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:provider/provider.dart';

class JuntoThemesPage extends StatelessWidget {
  const JuntoThemesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0,
          titleSpacing: 0,
          brightness: Theme.of(context).brightness,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                Text(
                  S.of(context).themes_title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: _NightModeSwitch(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: <Widget>[
                _ThemeSelector('rainbow'),
                _ThemeSelector('aqueous'),
                _ThemeSelector('royal'),
                _ThemeSelector('fire'),
                _ThemeSelector('forest'),
                _ThemeSelector('sand'),
                _ThemeSelector('dark'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector(
    this.name, {
    Key key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .15,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await Provider.of<JuntoThemesProvider>(context, listen: false)
              .setTheme(name);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/junto-mobile__themes--$name.png',
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  name == 'royal' ? 'PURPLE GOLD' : name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NightModeSwitch extends StatelessWidget {
  const _NightModeSwitch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
      builder: (context, theme, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              theme.nightMode
                  ? S.of(context).themes_night
                  : S.of(context).themes_light,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Transform.scale(
              scale: .8,
              child: Switch.adaptive(
                value: theme.nightMode,
                onChanged: (bool value) async {
                  final themes =
                      Provider.of<JuntoThemesProvider>(context, listen: false);
                  await themes.setNightMode(value);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        );
      },
    );
  }
}
