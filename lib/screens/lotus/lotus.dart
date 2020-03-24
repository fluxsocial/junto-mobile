import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres_temp.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class JuntoLotus extends StatefulWidget {
  const JuntoLotus({
    Key key,
    @required this.expressionContext,
    @required this.address,
  })  : assert(expressionContext != null),
        assert(address != ''),
        super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => JuntoLotusState();
}

class JuntoLotusState extends State<JuntoLotus> {
  static Route<dynamic> route() {
    return FadeRoute<void>(
      child: const JuntoLotus(
        address: null,
        expressionContext: ExpressionContext.Collective,
      ),
      name: 'JuntoLotus',
    );
  }

  bool backButtonTappedOnce = false;
  ThemeData _currentTheme;

  /// Pushes new page onto the stack
  /// Allows to go back from the new page
  /// This way Lotus is always in the root of the app
  void _navigateTo(Screen screen) {
    final _userProfile =
        Provider.of<UserDataProvider>(context, listen: false).userProfile;
    Widget child;
    if (screen == Screen.collective) {
      child = JuntoCollective();
    } else if (screen == Screen.packs) {
      child = JuntoPacks(initialGroup: _userProfile.pack.address);
    } else if (screen == Screen.groups) {
      child = SpheresTemp();
    } else if (screen == Screen.create) {
      child = JuntoCreate(
        channels: const <String>[],
        address: widget.address,
        expressionContext: widget.expressionContext,
      );
    }
    backButtonTappedOnce = false;
    Navigator.of(context).push(
      FadeRoute<void>(child: child, name: child.runtimeType.toString()),
    );
    return;
  }

  void _handleLotusPress() {
    final Route<dynamic> route = ModalRoute.of(context);
    if (!route.isFirst) {
      Navigator.of(context).maybePop();
      return;
    }
    Navigator.of(context).push(
      FadeRoute<void>(child: JuntoCollective(), name: 'collective'),
    );
    return;
  }

  Future<void> getTheme() async {
    final theme = await Provider.of<JuntoThemesProvider>(context, listen: false)
        .getTheme();
    setState(() {
      _currentTheme = theme;
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dx) => Navigator.pop(context),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundTheme(currentTheme: _currentTheme),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(),
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _navigateTo(Screen.collective);
                              },
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 45,
                                      child: const Icon(
                                        CustomIcons.collective,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'COLLECTIVE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.4),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _navigateTo(Screen.groups);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * .5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      CustomIcons.spheres,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'GROUPS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.4,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateTo(Screen.packs);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * .5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      CustomIcons.packs,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'PACKS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.4,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _navigateTo(Screen.create);
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 27,
                                      child: const Icon(
                                        CustomIcons.create,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'CREATE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.4),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
