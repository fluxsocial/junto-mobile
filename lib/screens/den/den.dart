import 'dart:convert';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:junto_beta_mobile/widgets/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> with HideFab {
  final List<String> _tabs = <String>['About', 'Expressions'];
  UserRepo _userProvider;
  String _userAddress;
  UserData _userProfile;
  String _currentTheme;

  bool showComments = false;

  ScrollController _denController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  final AsyncMemoizer<List<CentralizedExpressionResponse>> _memoizer =
      AsyncMemoizer<List<CentralizedExpressionResponse>>();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

   _userProvider = Provider.of<UserRepo>(context);
    getUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    _denController.removeListener(_onScrollingHasChanged);
    _denController.dispose();
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
      _currentTheme = prefs.getString('current-theme');
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
                      currentTheme: _currentTheme,
                    ),
                    SliverPersistentHeader(
                      delegate: JuntoAppBarDelegate(
                        TabBar(
                          labelPadding: const EdgeInsets.all(0),
                          isScrollable: true,
                          labelColor: Theme.of(context).primaryColorDark,
                          labelStyle: Theme.of(context).textTheme.subtitle1,
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
                body: SafeArea(
                  child: TabBarView(
                    children: <Widget>[
                      _buildAbout(context),
                      // public expressions of user
                      _buildUserExpressions(),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: JuntoProgressIndicator(),
            ),
    );
  }

  /// Loads the user's personal expressions
  FutureBuilder<List<CentralizedExpressionResponse>> _buildUserExpressions() {
    return FutureBuilder<List<CentralizedExpressionResponse>>(
      future: getUsersExpressions(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Hmm, something is up with our server'),
          );
        }
        if (snapshot.hasData) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: CustomListView(
              data: snapshot.data,
              userAddress: _userAddress,
              privacyLayer: 'Public',
              showComments: false,
            ),
          );
        }
        return Center(
          child: JuntoProgressIndicator(),
        );
      },
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
        if (_userProfile.user.profilePicture.isNotEmpty)
          _displayProfilePictures(
            _userProfile.user.profilePicture,
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

  Widget _displayProfilePictures(List<String> profilePictures) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: CarouselSlider(
        viewportFraction: 1.0,
        height: MediaQuery.of(context).size.width - 20,
        enableInfiniteScroll: false,
        items: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              placeholder: (BuildContext context, String _) {
                return Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.2, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                  ),
                );
              },
              imageUrl: profilePictures[0],
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
