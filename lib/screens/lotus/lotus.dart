import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres_temp.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return const JuntoLotus(
          address: null,
          expressionContext: ExpressionContext.Collective,
        );
      },
      settings: const RouteSettings(name: 'JuntoLotus'),
    );
  }

  UserData _userProfile;
  String _currentTheme;
  String backgroundImageAsset;
  bool backButtonTappedOnce = false;

  @override
  void initState() {
    super.initState();

    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(
      prefs.getString('user_data'),
    );

    print(
      prefs.getString('current-theme'),
    );
    setState(() {
      _userProfile = UserData.fromMap(decodedUserData);
      _currentTheme = prefs.getString('current-theme');
    });
  }

  /// Pushes new page onto the stack
  /// Allows to go back from the new page
  /// This way Lotus is always in the root of the app
  void _navigateTo(Screen screen) {
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
        expressionCenterBackground: backgroundImageAsset,
      );
    }
    backButtonTappedOnce = false;
    Navigator.of(context).push(
      FadeRoute<void>(child: child, name: child.runtimeType.toString()),
    );
    return;
  }

  ImageProvider _setBackground() {
    setState(
      () {
        if (_currentTheme == 'aqueous' || _currentTheme == 'aqueous-night') {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--aqueous.png';
        } else if (_currentTheme == 'royal' || _currentTheme == 'royal-night') {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--royal.png';
        } else if (_currentTheme == 'rainbow' ||
            _currentTheme == 'rainbow-night') {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--rainbow.png';
        } else {
          backgroundImageAsset =
              'assets/images/junto-mobile__themes--rainbow.png';
        }
      },
    );
    return AssetImage(
      backgroundImageAsset,
    );
  }

  Future<bool> _willPop() async {
    if (backButtonTappedOnce) {
      return true;
    }
    // we prevent closing of the app when user taps back button
    // and show small message about that
    showFeedback(context, message: 'Press back again to exit');
    backButtonTappedOnce = true;
    return false;
  }

  void _handleLotusPress() {
    final Route<dynamic> route = ModalRoute.of(context);
    if (!route.isFirst) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context)
        .push(FadeRoute<void>(child: JuntoCollective(), name: 'collective'));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dx) => Navigator.pop(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _setBackground(),
              fit: BoxFit.cover,
            ),
          ),
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
      ),
    );
  }
}
