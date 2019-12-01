import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';

import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

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
  // ignore: unused_field
  String _currentPerspective = 'JUNTO';

  // ignore: unused_field
  String _appbarTitle = 'JUNTO';

  double _dx = 0.0;
  String _scrollDirection;

  UserProfile profile;

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  bool lotusVisible = false;

  ScrollController _collectiveController;
  final String newAppBarTitle = 'JUNTO';

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

    super.didChangeDependencies();
  }

  void _onScrollingHasChanged() {
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
        JuntoPerspectives(
          changePerspective: _changePerspective,
          profile: profile,
        ),
        GestureDetector(
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

                  endDrawer: const JuntoDrawer('Collective'),

                  // dynamically render body
                  body: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom,
                      left: MediaQuery.of(context).viewPadding.left + 4.0,
                      right: MediaQuery.of(context).viewPadding.right + 4.0,
                    ),
                    child: CustomScrollView(
                      controller: _collectiveController,
                      slivers: <Widget>[
                        SliverPersistentHeader(
                          delegate: CollectiveAppBar(
                            expandedHeight: 85,
                            newappbartitle: newAppBarTitle,
                            openPerspectivesDrawer: _openPerspectivesDrawer,
                          ),
                          pinned: false,
                          floating: true,
                        ),
                        _buildSliverList(context),
                      ],
                    ),
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

  Widget _buildSliverList(BuildContext context) {
    return FutureBuilder<List<CentralizedExpressionResponse>>(
      future: Provider.of<ExpressionRepo>(context).getCollectiveExpressions(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot,
      ) {
        if (snapshot.hasError)
          return SliverToBoxAdapter(
            child: Container(
              child: const Text('Error occured'),
            ),
          );
        if (!snapshot.hasData)
          return SliverToBoxAdapter(
            child: Container(
              child: SizedBox.fromSize(
                size: const Size.fromHeight(25.0),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (
              BuildContext context,
              int index,
            ) {
              return ExpressionPreview(expression: snapshot.data[index]);
            },
            childCount: snapshot.data.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
        );
      },
    );
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
