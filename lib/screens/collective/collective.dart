import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective_appbar.dart';

import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

// This class is a collective screen
class JuntoCollective extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoCollective();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective> with HideFab {
  final GlobalKey<ScaffoldState> _juntoCollectiveKey =
      GlobalKey<ScaffoldState>();
  AsyncMemoizer<void> readUserMemoizer = AsyncMemoizer<void>();

  // Default values for collective screen / JUNTO perspective - change dynamically.
  String _currentPerspective = 'JUNTO';
  String _appbarTitle = 'JUNTO';

  double _dx = 0.0;
  String _scrollDirection;

  UserProfile profile;

  ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  bool lotusVisible = false;

  bool isLoading = false;
  List<CentralizedExpressionResponse> initialData =
      <CentralizedExpressionResponse>[];

  ScrollController _collectiveController;
  String newappbartitle = 'JUNTO';
  @override
  void initState() {
    super.initState();
    _collectiveController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _collectiveController.addListener(_onScrollingHasChanged);
      if (_collectiveController.hasClients)
        _collectiveController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readUser();
    initialData
        .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
    super.didChangeDependencies();
  }

  _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, _isVisible);
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

  @override
  void dispose() {
    super.dispose();
    _collectiveController.dispose();
    _collectiveController.removeListener(_onScrollingHasChanged());
  }

  void _openPerspectivesDrawer() {
    if (_dx == 0) {
      setState(() {
        _dx = MediaQuery.of(context).size.width * .9;
      });
    }
  }
  // Future<void> _getData() async {
  //   if (!isLoading) {
  //     setState(() => isLoading = true);
  //   }
  //   await Future<void>.delayed(const Duration(milliseconds: 500), () {});
  //   isLoading = false;
  //   if (mounted)
  //     setState(() {
  //       isLoading = true;
  //       initialData
  //           .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
  //     });
  // }

  // Widget _buildLoadExpressions() {
  //   return GestureDetector(
  //     onTap: () {
  //       _getData();
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).colorScheme.background,
  //         gradient: LinearGradient(
  //           begin: Alignment.bottomLeft,
  //           end: Alignment.topRight,
  //           stops: <double>[0.2, 0.9],
  //           colors: <Color>[
  //             Theme.of(context).colorScheme.secondary,
  //             Theme.of(context).colorScheme.primary
  //           ],
  //         ),
  //       ),
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 10,
  //         vertical: 15,
  //       ),
  //       alignment: Alignment.center,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             'view 10 more expressions',
  //             style: TextStyle(
  //                 color: Theme.of(context).colorScheme.onPrimary,
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w700),
  //           ),
  //           const SizedBox(width: 2.5),
  //           Icon(Icons.keyboard_arrow_down,
  //               size: 13, color: Theme.of(context).colorScheme.onPrimary)
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
              key: _juntoCollectiveKey,

              floatingActionButton: ValueListenableBuilder(
                valueListenable: _isVisible,
                builder: (BuildContext context, bool visible, Widget child) {
                  return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: visible ? 1.0 : 0.0,
                      child: child);
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: BottomNav(
                      screen: 'collective',
                      function: () {
                        if (_dx == 0) {
                          setState(() {
                            _dx = MediaQuery.of(context).size.width * .9;
                          });
                        }
                      }),
                ),
              ),

              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,

              endDrawer: JuntoDrawer('Collective'),

              // dynamically render body
              body: CustomScrollView(
                controller: _collectiveController,
                slivers: <Widget>[
                  SliverPersistentHeader(
                      delegate: CollectiveAppBar(
                          expandedHeight: 85,
                          newappbartitle: newappbartitle,
                          openPerspectivesDrawer: _openPerspectivesDrawer),
                      pinned: false,
                      floating: true),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        color: Theme.of(context).backgroundColor,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                    right: 5,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      for (int index = 0;
                                          index < initialData.length + 1;
                                          index++)
                                        if (index == initialData.length)
                                          SizedBox()
                                        else if (index.isEven)
                                          ExpressionPreview(
                                              expression: initialData[index])
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 5,
                                    right: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      for (int index = 0;
                                          index < initialData.length + 1;
                                          index++)
                                        if (index == initialData.length)
                                          SizedBox()
                                        else if (index.isOdd)
                                          ExpressionPreview(
                                              expression: initialData[index])
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
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
