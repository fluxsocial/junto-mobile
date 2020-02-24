import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/groups/groups.dart';
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
    );
  }

  UserData _userProfile;
  String _currentTheme;
  String backgroundImageAsset;

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

  dynamic _navigateTo(String screen) {
    Navigator.of(context).push(
      PageRouteBuilder<dynamic>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          if (screen == 'Collective') {
            return JuntoCollective();
          } else if (screen == 'Groups') {
            return JuntoGroups(initialGroup: _userProfile.pack.address);
          } else if (screen == 'Create') {
            return JuntoCreate(
              channels: const <String>[],
              address: widget.address,
              expressionContext: widget.expressionContext,
              expressionCenterBackground: backgroundImageAsset,
            );
          } else {
            return JuntoCollective();
          }
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
  }

  Widget _setBackground() {
    setState(() {
      if (_currentTheme == 'aqueous') {
        backgroundImageAsset =
            'assets/images/junto-mobile__themes--aqueous.png';
      } else if (_currentTheme == 'royal') {
        backgroundImageAsset = 'assets/images/junto-mobile__themes--royal.png';
      } else if (_currentTheme == 'night') {
        backgroundImageAsset = 'assets/images/junto-mobile__themes--night.png';
      } else if (_currentTheme == 'rainbow') {
        backgroundImageAsset =
            'assets/images/junto-mobile__themes--rainbow.png';
      } else {
        backgroundImageAsset =
            'assets/images/junto-mobile__themes--rainbow.png';
      }
    });

    return Image.asset(
      backgroundImageAsset,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _setBackground(),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(bottom: 10),
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
                            _navigateTo('Create');
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
                  Container(
                    height: 80,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _navigateTo('Collective');
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
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                        GestureDetector(
                          onTap: () {
                            _navigateTo('Groups');
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
                                  CustomIcons.groups,
                                  size: 17,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
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
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (ModalRoute.of(context).isFirst) {
                              _navigateTo('Back');
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            color: Colors.transparent,
                            child: Icon(
                              CustomIcons.lotus,
                              size: 33,
                              color: Colors.white,
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
        )
      ]),
    );
  }
}
