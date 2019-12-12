import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  // Global key to uniquely identify Junto Collective
  final GlobalKey<ScaffoldState> _juntoCollectiveKey =
      GlobalKey<ScaffoldState>();

  // for custom swipe to open perspectives drawer animation
  double _dx = 0.0;
  String _scrollDirection;

  ExpressionRepo _expressionProvider;
  String _userAddress;
  UserData _userProfile;

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  ScrollController _collectiveController;
  String _appbarTitle = 'JUNTO';
  bool _showDegrees = true;
  String currentDegree = 'oo';
  Future _currentFeed;

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

    getUserInformation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _expressionProvider = Provider.of<ExpressionRepo>(context);
      _currentFeed =
          getCollectiveExpressions(contextType: 'Collective', contextId: null);
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, _isVisible);
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<dynamic> getCollectiveExpressions(
      {dynamic dos,
      String contextType,
      List<String> channels,
      dynamic contextId}) async {
    final Map<String, dynamic> _params = <String, dynamic>{
      'contextType': contextType,
      'contextId': contextId
    };
    print('from collective ');

    return await _expressionProvider.getCollectiveExpressions(_params);
  }

  @override
  void dispose() {
    super.dispose();
    _collectiveController.dispose();
    _collectiveController.removeListener(_onScrollingHasChanged);
  }

  void _openPerspectivesDrawer() {
    if (_dx == 0) {
      setState(() {
        _dx = MediaQuery.of(context).size.width * .9;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _userProfile != null
            ? JuntoPerspectives(
                changePerspective: _changePerspective,
                profile: _userProfile,
              )
            : const SizedBox(),
        GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details) {
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
            child: Stack(
              children: <Widget>[
                Scaffold(
                  key: _juntoCollectiveKey,
                  floatingActionButton: ValueListenableBuilder<bool>(
                    valueListenable: _isVisible,
                    builder:
                        (BuildContext context, bool visible, Widget child) {
                      return AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: visible ? 1.0 : 0.0,
                          child: child);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: BottomNav(
                          screen: 'collective',
                          onTap: () {
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
                  endDrawer: const JuntoDrawer(
                      screen: 'Collective', icon: CustomIcons.collective),

                  // dynamically render body
                  body: FutureBuilder<dynamic>(
                    future: _currentFeed,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<dynamic> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Transform.translate(
                            offset: const Offset(0.0, 0.0),
                            child: const Text(
                                'hmm, something is up with our servers'),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return CustomScrollView(
                          controller: _collectiveController,
                          slivers: <Widget>[
                            SliverPersistentHeader(
                              delegate: CollectiveAppBar(
                                expandedHeight: _showDegrees == true ? 135 : 85,
                                degrees: _showDegrees,
                                currentDegree: currentDegree,
                                switchDegree: _switchDegree,
                                appbarTitle: _appbarTitle,
                                openPerspectivesDrawer: _openPerspectivesDrawer,
                              ),
                              pinned: false,
                              floating: true,
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(<Widget>[
                                Container(
                                  color: Theme.of(context).backgroundColor,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              right: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                for (int index = 0;
                                                    index <
                                                        snapshot.data.length +
                                                            1;
                                                    index++)
                                                  if (index ==
                                                      snapshot.data.length)
                                                    const SizedBox()
                                                  else if (index.isEven)
                                                    ExpressionPreview(
                                                      expression:
                                                          snapshot.data[index],
                                                    )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 5,
                                              right: 10,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                for (int index = 0;
                                                    index <
                                                        snapshot.data.length +
                                                            1;
                                                    index++)
                                                  if (index ==
                                                      snapshot.data.length)
                                                    const SizedBox()
                                                  else if (index.isOdd)
                                                    ExpressionPreview(
                                                      expression:
                                                          snapshot.data[index],
                                                    )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                            )
                          ],
                        );
                      }
                      return Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, 0.0),
                          child: JuntoProgressIndicator(),
                        ),
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
                          color:
                              Theme.of(context).backgroundColor.withOpacity(.5),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

// switch bgetween degrees of separation
  void _switchDegree({String degreeName, int degreeNumber}) {
    setState(() {
      // _currentFeed = getCollectiveExpressions(
      //     contextId: null, contextType: 'Dos', dos: degreeNumber);
      _showDegrees = true;
    });
    setState(() {
      currentDegree = degreeName;
    });
  }

// Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(dynamic perspective) {
    if (perspective == 'JUNTO') {
      setState(() {
        _currentFeed = getCollectiveExpressions(
            contextId: null, contextType: 'Collective', dos: null);
        _showDegrees = true;
        _appbarTitle = 'JUNTO';
      });
    } else {
      setState(() {
        _currentFeed = getCollectiveExpressions(
            contextId: perspective.address,
            contextType: 'FollowPerspective',
            dos: null);
        _showDegrees = false;
        if (perspective.name ==
            _userProfile.user.name + "'s Follow Perspective") {
          _appbarTitle = 'Subscriptions';
        } else {
          _appbarTitle = perspective.name;
        }
      });
    }

    setState(
      () {
        _dx = 0;
      },
    );
    _collectiveController
      ..animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
  }
}
