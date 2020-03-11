import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoThemes extends StatefulWidget {
  const JuntoThemes({this.refreshData, this.currentTheme, this.nightMode});

  final Function refreshData;
  final String currentTheme;
  final bool nightMode;

  @override
  State<StatefulWidget> createState() {
    return JuntoThemesState();
  }
}

class JuntoThemesState extends State<JuntoThemes> {
  bool _nightMode;
  String _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.currentTheme;
    if (widget.nightMode == null) {
      _nightMode = false;
    } else {
      _nightMode = widget.nightMode;
    }
  }

  Widget _themeSelector(BuildContext context, String theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .15,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _currentTheme = theme;
          });
          if (_nightMode) {}
          Provider.of<JuntoThemesProvider>(context, listen: false)
              .setTheme(_nightMode ? theme + '-night' : theme);
          widget.refreshData();
        },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
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
                        setState(() {
                          _nightMode = value;
                        });
                        String theme;
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        if (value) {
                          theme = _currentTheme + '-night';
                          prefs.setBool('night-mode', true);
                        } else if (!value) {
                          theme = _currentTheme;
                          print(theme);
                          prefs.setBool('night-mode', false);
                        }
                        Provider.of<JuntoThemesProvider>(context, listen: false)
                            .setTheme(theme);
                        widget.refreshData();
                      },
                      activeColor: Theme.of(context).dividerColor,
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
