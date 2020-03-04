import 'dart:convert';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:junto_beta_mobile/widgets/user_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/zoom_scaffold.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen>
    with HideFab, TickerProviderStateMixin {
  final List<String> _tabs = <String>['ABOUT', 'EXPRESSIONS'];
  UserData _userProfile;
  String _currentTheme;

  bool showComments = false;

  ScrollController _denController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  MenuController menuController;

  @override
  void initState() {
    super.initState();
    _denController = ScrollController();
    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _denController.addListener(_onScrollingHasChanged);
      if (_denController.hasClients)
        _denController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    _denController.removeListener(_onScrollingHasChanged);
    _denController.dispose();
    menuController.dispose();
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_denController, _isVisible);
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userProfile = UserData.fromMap(decodedUserData);
      _currentTheme = prefs.getString('current-theme');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuController>.value(
      value: menuController,
      child: ZoomScaffold(
        menuScreen: JuntoDrawer(),
        contentScreen: Layout(
          contentBuilder: (BuildContext context) => Scaffold(
            appBar: _userProfile != null
                ? DenAppbar(heading: _userProfile.user.username)
                : const PreferredSize(
                    preferredSize: Size.fromHeight(45),
                    child: SizedBox(),
                  ),
            floatingActionButton: ValueListenableBuilder<bool>(
              valueListenable: _isVisible,
              builder: (
                BuildContext context,
                bool visible,
                Widget child,
              ) {
                return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: visible ? 1.0 : 0.0,
                    child: child);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: BottomNav(
                    actionsVisible: false,
                    screen: 'den',
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<Widget>(
                          builder: (BuildContext context) => JuntoEditDen(),
                        ),
                      );
                    }),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: _userProfile != null
                ? DefaultTabController(
                    length: _tabs.length,
                    child: NestedScrollView(
                      controller: _denController,
                      physics: const ClampingScrollPhysics(),
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          JuntoDenSliverAppbar(
                            profile: _userProfile,
                            currentTheme: _currentTheme,
                          ),
                          SliverPersistentHeader(
                            delegate: JuntoAppBarDelegate(
                              TabBar(
                                labelPadding: const EdgeInsets.all(0),
                                isScrollable: true,
                                labelColor: Theme.of(context).primaryColorDark,
                                labelStyle:
                                    Theme.of(context).textTheme.subtitle1,
                                indicatorWeight: 0.0001,
                                tabs: <Widget>[
                                  for (String name in _tabs)
                                    Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      child: Tab(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: SafeArea(
                        child: TabBarView(
                          children: <Widget>[
                            _buildAbout(context),
                            // public expressions of user
                            UserExpressions(
                              privacy: 'Public',
                              userProfile: _userProfile.user,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: JuntoProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  /// Loads and displays the user's profile information stored in the server.
  Widget _buildAbout(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 10),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            children: <Widget>[
              _displayAboutItem(
                _userProfile.user.gender,
                Icon(CustomIcons.gender,
                    size: 17, color: Theme.of(context).primaryColor),
              ),
              _displayAboutItem(
                _userProfile.user.location,
                Image.asset(
                  'assets/images/junto-mobile__location.png',
                  height: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              _displayAboutItem(
                _userProfile.user.website,
                Image.asset(
                  'assets/images/junto-mobile__link.png',
                  height: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Text(
            _userProfile.user.bio,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  /// Displays the user's profile information as an Item tile.
  Widget _displayAboutItem(List<String> item, dynamic icon) {
    if (item.isNotEmpty && item[0].isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            icon,
            const SizedBox(width: 5),
            Text(
              item[0],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
