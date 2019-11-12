import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_drawer.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/screens/spheres/spheres.dart';
import 'package:junto_beta_mobile/screens/template/perspectives.dart';
import 'package:junto_beta_mobile/widgets/appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/fabs/create_sphere_fab.dart';
import 'package:junto_beta_mobile/widgets/fabs/filter_channel_fab.dart';
import 'package:provider/provider.dart';

// This class is a template screen that contains the navbar, bottom bar,
// and screen (collective, spheres, pack, etc) depending on condition.
class JuntoTemplate extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoTemplate();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => JuntoTemplateState();
}

class JuntoTemplateState extends State<JuntoTemplate> {
  final GlobalKey<ScaffoldState> _juntoTemplateKey = GlobalKey<ScaffoldState>();
  AsyncMemoizer<void> readUserMemoizer = AsyncMemoizer<void>();

  // Default values for collective screen / JUNTO perspective - change dynamically.
  String _currentScreen = 'collective';
  String _currentPerspective = 'JUNTO';
  String _appbarTitle = 'JUNTO';

  ValueNotifier<int> _bottomNavIndex;
  ScrollController collectiveController;

  double _dx = 0.0;
  String _scrollDirection;

  UserProfile profile;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = ValueNotifier<int>(0);
    collectiveController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readUser();
  }

  Future<void> _readUser() {
    return readUserMemoizer.runOnce(() => _retrieveUserInfo());
  }

  Future<void> _retrieveUserInfo() async {
    final UserRepo _userProvider = Provider.of<UserRepo>(context);
    try {
      final UserData _profile = await _userProvider.readLocalUser();
      setState(() {
        profile = _profile.user;
      });
    } catch (error, stack) {
      debugPrint('Error occured in _retrieveUserInfo: $error,  $stack');
    }
  }

  _displayFAB() {
    if (_currentScreen == 'collective') {
      return FilterChannelFAB();
    } else if (_currentScreen == 'spheres') {
      return CreateSphereFAB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      JuntoPerspectives(changePerspective: _changePerspective),
      GestureDetector(
        onTap: () {
          print('yo');
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          // only enable drag on collective screen
          if (_currentScreen == 'collective') {
            if (_dx == 0.0 &&
                details.globalPosition.dy != 0.0 &&
                details.delta.direction > 0) {
              return;
            } else {
              if (details.globalPosition.dx > 0 &&
                  details.globalPosition.dx <
                      MediaQuery.of(context).size.width * .9) {
                setState(() {
                  _dx = details.globalPosition.dx;
                  if (details.delta.direction > 0) {
                    setState(() {
                      _scrollDirection = 'left';
                    });
                  } else if (details.delta.direction < 0) {
                    setState(() {
                      _scrollDirection = 'right';
                    });
                  }
                });
              }
            }
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_scrollDirection == 'right') {
            if (_dx >= MediaQuery.of(context).size.width * .2) {
              setState(() {
                _dx = MediaQuery.of(context).size.width * .9;
              });
            } else if (_dx < MediaQuery.of(context).size.width * .2) {
              _dx = 0.0;
            }
          } else if (_scrollDirection == 'left') {
            if (_dx < MediaQuery.of(context).size.width * .7) {
              setState(() {
                _dx = 0.0;
              });
            } else if (_dx >= MediaQuery.of(context).size.width * .7) {
              setState(() {
                _dx = MediaQuery.of(context).size.width * .9;
              });
            }
          }
        },
        child: Transform.translate(
          offset: Offset(_dx, 0.0),
          child: Stack(children: <Widget>[
            Scaffold(
              key: _juntoTemplateKey,
              appBar: JuntoAppBar(
                appContext: _currentScreen,
                openPerspectivesDrawer: () {
                  if (_dx == 0) {
                    setState(() {
                      _dx = MediaQuery.of(context).size.width * .9;
                    });
                  }
                },
                juntoAppBarTitle: _appbarTitle,
              ),
              floatingActionButton: _displayFAB(),
              // floatingActionButton:
              //     const CreateFAB(expressionLayer: 'collective'),

              // only enable drawer if current screen is collective
              // drawer: _currentScreen == 'collective'
              //     ? WillPopScope(
              //         onWillPop: () async {
              //           return false;
              //         },
              //         child: Perspectives(
              //           changePerspective: _changePerspective,
              //           profile: profile,
              //         ),
              //       )
              //     : null,
              // only enable end drawer if current screen is den
              endDrawer: _currentScreen == 'den'
                  ? WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: DenDrawer())
                  : null,

              // dynamically render body
              body: _renderBody(),

              bottomNavigationBar: ValueListenableBuilder<int>(
                valueListenable: _bottomNavIndex,
                builder: (BuildContext context, int index, _) {
                  return BottomNav(
                    currentIndex: index,
                    setIndex: _switchScreen,
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_dx == MediaQuery.of(context).size.width * .9) {
                  setState(() {
                    _dx = 0;
                  });
                }
              },
              child: _dx > 0
                  ? Container(
                      color: Theme.of(context).backgroundColor.withOpacity(.5),
                    )
                  : const SizedBox(),
            )
          ]),
        ),
      ),
    ]);
  }

  // render main body of template; i.e. collective, spheres, packs, or den
  Widget _renderBody() {
    switch (_currentScreen) {
      case 'collective':
        return JuntoCollective(
            currentPerspective: _currentPerspective,
            controller: collectiveController);

      case 'spheres':
        return JuntoSpheres(
          userProfile: profile,
        );
      case 'packs':
        return JuntoPacks();
      case 'den':
        return JuntoDen();
    }
    return Container();
  }

  // switch screen and update appbar title
  void _switchScreen(int x) {
    _bottomNavIndex.value = x;

    switch (x) {
      case 0:
        setState(() {
          _currentScreen = 'collective';
          _appbarTitle = 'JUNTO';
        });
        if (collectiveController.hasClients)
          collectiveController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        break;
      case 1:
        setState(() {
          _currentScreen = 'spheres';
          _appbarTitle = 'SPHERES';
        });

        break;
      case 2:
        setState(() {
          _currentScreen = 'packs';
          _appbarTitle = 'PACKS';
        });

        break;
      case 3:
        setState(() {
          _currentScreen = 'den';
          // _appbarTitle = profile?.username ?? 'sunyata';
          _appbarTitle = 'sunyata';
        });

        break;
    }
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(String perspective) {
    setState(
      () {
        _currentPerspective = perspective;
        _appbarTitle = perspective;
        _dx = 0;
      },
    );
  }
}
