import 'package:async/async.dart' show AsyncMemoizer;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den_appbar_new.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> with HideFab {
  String profilePicture = 'assets/images/junto-mobile__logo.png';
  final List<String> _tabs = <String>['About', 'Public', 'Private'];
  bool publicExpressionsActive = true;
  bool publicCollectionActive = false;
  bool privateExpressionsActive = true;
  bool privateCollectionActive = false;

  AsyncMemoizer<UserData> userMemoizer = AsyncMemoizer<UserData>();
  List<CentralizedExpressionResponse> expressions;

  Future<UserData> _retrieveUserInfo() async {
    final UserRepo _userProvider = Provider.of<UserRepo>(context);
    return userMemoizer.runOnce(() => _userProvider.readLocalUser());
  }

  ScrollController _denController;
  final GlobalKey<ScaffoldState> _juntoDenKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _denController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _denController.addListener(_onScrollingHasChanged);
      if (_denController.hasClients)
        _denController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_denController, _isVisible);
  }

  @override
  void dispose() {
    super.dispose();
    _denController.dispose();
    _denController.removeListener(_onScrollingHasChanged);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      key: _juntoDenKey,
      appBar: const DenAppbar(heading: 'Den'),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (BuildContext context, bool visible, Widget child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: visible ? 1.0 : 0.0,
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: BottomNav(
              screen: 'den',
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<dynamic>(
                    builder: (BuildContext context) => JuntoEditDen(),
                  ),
                );
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: const JuntoDrawer('Den'),
      body: FutureBuilder<UserData>(
        future: _retrieveUserInfo(),
        builder: (
          BuildContext context,
          AsyncSnapshot<UserData> snapshot,
        ) {
          if (snapshot.hasData)
            return DefaultTabController(
              length: _tabs.length,
              child: NestedScrollView(
                controller: _denController,
                physics: const ClampingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    JuntoDenSliverAppbar(
                      handle: snapshot.data.user.username,
                      name: snapshot.data.user.name,
                      profilePicture: 'assets/images/junto-mobile__eric.png',
                      bio: snapshot.data.user.bio,
                    ),
                    SliverPersistentHeader(
                      delegate: JuntoAppBarDelegate(
                        TabBar(
                          labelPadding: const EdgeInsets.all(0),
                          isScrollable: true,
                          labelColor: Theme.of(context).primaryColorDark,
                          labelStyle: Theme.of(context).textTheme.subhead,
                          indicatorWeight: 0.0001,
                          tabs: <Widget>[
                            for (String name in _tabs)
                              Container(
                                margin: const EdgeInsets.only(right: 24),
                                color: Theme.of(context).colorScheme.background,
                                child: Tab(
                                  text: name,
                                ),
                              ),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: <Widget>[
                    ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(left: 10),
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(CustomIcons.gender,
                                        size: 17,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      'he/him',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/junto-mobile__location.png',
                                      height: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Spirit',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/junto-mobile__link.png',
                                      height: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'junto.foundation',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CarouselSlider(
                          viewportFraction: 1.0,
                          height: MediaQuery.of(context).size.width - 20,
                          enableInfiniteScroll: false,
                          items: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                  'assets/images/junto-mobile__eric.png',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                  'assets/images/junto-mobile__eric--qigong.png',
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          child: Text(
                            snapshot.data.user.bio,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                    UserExpressions(
                      key: const PageStorageKey<String>(
                          'public-user-expressions'),
                      privacy: 'Public',
                      userProfile: snapshot.data.user,
                    ),
                    UserExpressions(
                      key: const PageStorageKey<String>(
                          'private-user-expressions'),
                      privacy: 'Private',
                      userProfile: snapshot.data.user,
                    )
                  ],
                ),
              ),
            );
          if (snapshot.hasError) {
            return Container(
              height: media.size.height,
              width: media.size.width,
              child: Center(
                child: Text('Error occured ${snapshot.error}'),
              ),
            );
          }
          return Container(
            height: media.size.height,
            width: media.size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
