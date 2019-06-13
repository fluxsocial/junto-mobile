import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';

import '../collective/perspectives/perspectives.dart';
import '../collective/collective.dart';
import '../collective/filter_screen/filter_screen.dart';
import '../collective/filter_fab/filter_fab.dart';
import '../spheres/spheres.dart';
import '../packs/packs.dart';
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
  ScrollController _hideFABController = ScrollController();
  bool _isVisible = true;

  bool _filterOn = false;
  @override
  void initState() {
    _hideFABController.addListener(() {
      if (_hideFABController.position.userScrollDirection == ScrollDirection.idle) {
        setState(() {
          _isVisible = true;
        });
      }           
      else if (_hideFABController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }       
      else if (_hideFABController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      } 
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Stack(children: [
        ScopedModelDescendant<ScopedUser>(
        builder: (context, child, model) => Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(preferredSize: Size.fromHeight(45), child: JuntoAppBar(_appbarLogo, _appbarTitle,
                _appbarBorderRight,_appbarBorderLeft, _navNotifications)),
            floatingActionButton: _currentScreen == 'collective'
                ? CollectiveFilterFAB(_isVisible, _toggleFilter)
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
            body: 
                PageView(
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
                    JuntoPacks(),
                    JuntoDen()
                  ],
                ),                      
                bottomNavigationBar: BottomNav(_bottomNavIndex, _setBottomIndex))),

                // Render Filter Channels Screen conditionally
                _filterOn ? CollectiveFilterScreen(_isVisible, _toggleFilter) : SizedBox(),            
            ]);
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
  
  // Navigate to Notifications screen
  _navNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  // Toggle filter FAB
  _toggleFilter() {
    if(_filterOn) {
      setState(() {
        _filterOn = false;
      });      
    } else if(_filterOn == false) {
      setState(() {
        _filterOn = true;
      });         
    }
  }
}
