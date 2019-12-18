import 'dart:convert';
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> with HideFab {
  final List<String> _tabs = <String>['About', 'Public', 'Private'];
  UserRepo _userProvider;
  String _userAddress;
  UserData _userProfile;

  ScrollController _denController;
  final GlobalKey<ScaffoldState> _juntoDenKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  final AsyncMemoizer<List<CentralizedExpressionResponse>> _memoizer =
      AsyncMemoizer<List<CentralizedExpressionResponse>>();

  @override
  void initState() {
    super.initState();
    _denController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _denController.addListener(_onScrollingHasChanged);
      _denController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
    getUserInformation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _userProvider = Provider.of<UserRepo>(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _denController.dispose();
    _denController.removeListener(_onScrollingHasChanged);
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_denController, _isVisible);
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

  Future<List<CentralizedExpressionResponse>> getUsersExpressions() async {
    return _memoizer.runOnce(
      () => _userProvider.getUsersExpressions(_userAddress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _juntoDenKey,
      appBar: _userProfile != null
          ? DenAppbar(heading: _userProfile.user.username)
          : const PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: SizedBox(),
            ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (BuildContext context, bool visible, Widget child) {
          return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: visible ? 1.0 : 0.0,
              child: child);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: BottomNav(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: const JuntoDrawer(screen: 'Den', icon: CustomIcons.create),
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
                      name: _userProfile.user.name,
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
                        Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            children: <Widget>[
                              _displayAboutItem(
                                _userProfile.user.gender,
                                Icon(CustomIcons.gender,
                                    size: 17,
                                    color: Theme.of(context).primaryColor),
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
                        _displayProfilePictures(
                            _userProfile.user.profilePicture),
                        const SizedBox(height: 15),
                        Container(
                          child: Text(_userProfile.user.bio,
                              style: Theme.of(context).textTheme.caption),
                        ),
                      ],
                    ),

                    // public expressions of user
                    FutureBuilder<List<CentralizedExpressionResponse>>(
                      future: getUsersExpressions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CentralizedExpressionResponse>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Transform.translate(
                              offset: const Offset(0.0, -50),
                              child: const Text(
                                  'Hmm, something is up with our server'),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            color: Theme.of(context).colorScheme.background,
                            child: ListView(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5, top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isEven &&
                                                snapshot.data[index].privacy ==
                                                    'Public')
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                              )
                                            else
                                              const SizedBox()

                                          // even number indexes
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 10, top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // odd number indexes
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isOdd &&
                                                snapshot.data[index].privacy ==
                                                    'Public')
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                              )
                                            else
                                              const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: Transform.translate(
                            offset: const Offset(0.0, -50),
                            child: JuntoProgressIndicator(),
                          ),
                        );
                      },
                    ),

                    // private expressions of user
                    FutureBuilder<List<CentralizedExpressionResponse>>(
                      future: getUsersExpressions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CentralizedExpressionResponse>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('something is up'),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            color: Theme.of(context).colorScheme.background,
                            child: ListView(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 5, top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isEven &&
                                                snapshot.data[index].privacy ==
                                                    'Private')
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                              )
                                            else
                                              const SizedBox()

                                          // even number indexes
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 10, top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // odd number indexes
                                          for (int index = 0;
                                              index < snapshot.data.length + 1;
                                              index++)
                                            if (index == snapshot.data.length)
                                              const SizedBox()
                                            else if (index.isOdd &&
                                                snapshot.data[index].privacy ==
                                                    'Private')
                                              ExpressionPreview(
                                                expression:
                                                    snapshot.data[index],
                                              )
                                            else
                                              const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: Transform.translate(
                            offset: const Offset(0.0, -50),
                            child: JuntoProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50),
                child: JuntoProgressIndicator(),
              ),
            ),
    );
  }

  Widget _displayAboutItem(List<String> item, dynamic icon) {
    if (item != null) {
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

  Widget _displayProfilePictures(List<String> profilePictures) {
    if (profilePictures != null) {
      return CarouselSlider(
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.width - 20,
          enableInfiniteScroll: false,
          items: <Widget>[
            for (String picture in profilePictures)
              Container(
                padding: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width,
                child: Image.asset(picture, fit: BoxFit.cover),
              ),
          ]);
    } else {
      return const SizedBox();
    }
  }
}

