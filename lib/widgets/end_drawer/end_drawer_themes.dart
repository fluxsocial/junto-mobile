import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class JuntoThemes extends StatefulWidget {
  const JuntoThemes();

  @override
  State<StatefulWidget> createState() {
    return JuntoThemesState();
  }
}

class JuntoThemesState extends State<JuntoThemes> {
  String _currentTheme = 'rainbow';
  bool _nightMode = false;

  @override
  void initState() {
    super.initState();
    getThemeInfo();
  }

  Future<void> getThemeInfo() async {
    final box = await Hive.box(HiveBoxes.kAppBox);
    //TODO: don't use box for that here
    final bool nightMode = await box.get('night-mode');
    final String theme = await box.get("current-theme") as String;
    if (nightMode != null) {
      setState(() {
        _nightMode = nightMode;
        _currentTheme = theme;
      });
    }
  }

  Future<void> setTheme(String theme) async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        duration: 400,
      );
    }
    setState(() {
      if (_nightMode) {
        if (!_currentTheme.contains('-night')) {
          _currentTheme = '$theme-night';
        } else {
          _currentTheme = theme;
        }
      } else if (!_nightMode) {
        if (_currentTheme.contains('-night')) {
          _currentTheme =
              _currentTheme.replaceRange(theme.length - 6, theme.length, '');
        } else {
          _currentTheme = theme;
        }
      }
    });

    await Provider.of<JuntoThemesProvider>(context, listen: false)
        .setTheme(_currentTheme);
  }

  Widget _themeSelector(BuildContext context, String theme) {
    return GestureDetector(
      onTap: () async {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(
            duration: 400,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .15,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            setState(() {
              _currentTheme = theme;
            });
            await Provider.of<JuntoThemesProvider>(context, listen: false)
                .setTheme(_nightMode ? '$theme-night' : theme);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/junto-mobile__themes--$theme.png',
                  height: MediaQuery.of(context).size.height * .15,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    theme == 'royal' ? 'PURPLE GOLD' : theme.toUpperCase(),
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
                  'Themes',
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _nightMode ? 'Night' : 'Light',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Transform.scale(
                    scale: .8,
                    child: Switch.adaptive(
                      value: _nightMode,
                      onChanged: (bool value) async {
                        final box = await Hive.box(HiveBoxes.kAppBox);
                        //TODO: don't use box here
                        await box.delete('night-mode');
                        await box.put('night-mode', value);
                        setState(() {
                          _nightMode = value;
                        });
                        setTheme(_currentTheme);
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  )
                ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: <Widget>[
                _themeSelector(context, 'rainbow'),
                _themeSelector(context, 'aqueous'),
                _themeSelector(context, 'royal'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
