import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';

import '../collective/perspectives/perspectives.dart';
import '../collective/collective.dart';
import '../spheres/spheres.dart';
import '../pack/pack.dart';
import '../den/den.dart';
import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import '../../scoped_models/scoped_user.dart';
import '../../typography/palette.dart';

// This class is a template screen that contains the navbar, bottom bar,
// and screen (collective, spheres, pack, etc) depending on condition.

class JuntoTemplate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoTemplateState();
  }
}

class JuntoTemplateState extends State<JuntoTemplate> {
  // Default values for collective screen / JUNTO perspective - change dynamically.
  var _currentScreen = 'collective';
  String _currentPerspective = 'JUNTO';
  String _appbarLogo = 'assets/images/junto-mobile__logo--collective.png';
  String _appbarTitle = 'JUNTO';
  Color _appbarBorderLeft = JuntoPalette.juntoBlue;
  Color _appbarBorderRight = JuntoPalette.juntoBlueLight;
  int _bottomNavIndex = 0;

  // Controller for PageView
  final controller = PageController(initialPage: 0);

  // Controller for scroll
  ScrollController _hideFABController;
  bool _isVisible;

  @override
  void initState() {
    _isVisible = true;
    _hideFABController = ScrollController();

    _hideFABController.addListener(() {
      if (_hideFABController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      } else if (_hideFABController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedUser>(
        builder: (context, child, model) => Scaffold(
            backgroundColor: Colors.white,
            appBar: JuntoAppBar.getJuntoAppBar(_appbarLogo, _appbarTitle,
                _appbarBorderLeft, _appbarBorderRight, _navNotifications),
            floatingActionButton: _currentScreen == 'collective'
                ? AnimatedOpacity(                  
                    duration: Duration(milliseconds: 200),          
                    opacity: _isVisible ? 1 : 0,
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                JuntoPalette.juntoPurple,
                                JuntoPalette.juntoBlue
                              ]),
                          color: Colors.white.withOpacity(.5),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text('#',
                            style: TextStyle(color: Color(0xffffffff)))),
                  )
                : null,
            drawer:
                // only enable drawer if current screen is collective
                _currentScreen == 'collective'
                    ? WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: Perspectives(_changePerspective),
                      )
                    : null,
            body: PageView(
              controller: controller,
              onPageChanged: (int) {
                if (int == 0) {
                  _switchScreen('collective');
                } else if (int == 1) {
                  _switchScreen('spheres');

                } else if (int == 2) {
                  _switchScreen('packs');

                } else if (int == 3) {
                  _switchScreen('den');
                }
              },
              children: <Widget>[
                JuntoCollective(_hideFABController),
                JuntoSpheres(),
                JuntoPack(),
                JuntoDen()
              ],
            ),
            bottomNavigationBar: BottomNav(_bottomNavIndex, _setBottomIndex)));
  }

  // Set the bottom navbar index; used when bottom nav icon is pressed.
  _setBottomIndex(x) {
    setState(() {
      _bottomNavIndex = x;
      controller.jumpToPage(x);
    });
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(perspective) {
    setState(() {
      _currentPerspective = perspective;
      _appbarTitle = perspective;

      // re render feed
    });
  }

  // Switch between screens within PageView
  _switchScreen(screen) {
    if(screen == 'collective') {
      setState(() {
        _currentScreen = 'collective';
        _appbarTitle = 'JUNTO';
        _appbarLogo =
            'assets/images/junto-mobile__logo--collective.png';
        _appbarBorderLeft = JuntoPalette.juntoBlue;
        _appbarBorderRight = JuntoPalette.juntoBlueLight;
        _bottomNavIndex = 0;
      });      
    } else if (screen == 'spheres') {
      setState(() {
        _currentScreen = 'spheres';
        _appbarTitle = 'SPHERES';
        _appbarLogo =
            'assets/images/junto-mobile__logo--spheres.png';
        _appbarBorderLeft = JuntoPalette.juntoGreen;
        _appbarBorderRight = JuntoPalette.juntoGreenLight;

        _bottomNavIndex = 1;
      });      
    } else if (screen == 'packs') {
        setState(() {
          _currentScreen = 'packs';
          _appbarTitle = 'PACKS';
          _appbarLogo = 'assets/images/junto-mobile__logo--pack.png';
          _appbarBorderLeft = JuntoPalette.juntoPurple;
          _appbarBorderRight = JuntoPalette.juntoPurpleLight;
          _bottomNavIndex = 2;
        });     
    } else if (screen == 'den') {
      setState(() {
        _currentScreen = 'den';
        _appbarTitle = 'DEN';
        _appbarLogo = 'assets/images/junto-mobile__logo--den.png';
        _appbarBorderLeft = JuntoPalette.juntoGrey;
        _appbarBorderRight = JuntoPalette.juntoSleek;
        _bottomNavIndex = 3;      
      });
    }
  }
  
  _navNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }
}
