import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/den/den_collection_preview.dart';
import 'package:junto_beta_mobile/screens/den/den_create_collection.dart';
import 'package:junto_beta_mobile/screens/den/den_expanded.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart' show AsyncMemoizer;

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> {
  String profilePicture = 'assets/images/junto-mobile__eric.png';
  final ValueNotifier<UserProfile> _profile = ValueNotifier<UserProfile>(
      UserProfile(username: '', bio: '', firstName: '', lastName: ''));
  bool publicExpressionsActive = true;
  bool publicCollectionActive = false;
  bool privateExpressionsActive = true;
  bool privateCollectionActive = false;

  PageController controller;
  AsyncMemoizer<UserProfile> userMemoizer;
  List<CentralizedExpressionResponse> expressions;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    userMemoizer = AsyncMemoizer<UserProfile>();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    userMemoizer = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveUserInfo();
    expressions =
        Provider.of<CollectiveProvider>(context).collectiveExpressions;
  }

  Future<void> _retrieveUserInfo() async {
    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    final UserProfile _results =
        await userMemoizer.runOnce(() => _userProvider.readLocalUser());
    _profile.value = _results;
  }

  void _togglePublicDomain(String domain) {
    if (domain == 'expressions') {
      setState(() {
        publicExpressionsActive = true;
        publicCollectionActive = false;
      });
    } else if (domain == 'collection') {
      setState(() {
        publicExpressionsActive = false;
        publicCollectionActive = true;
      });
    }
  }

  void _togglePrivateDomain(String domain) {
    if (domain == 'expressions') {
      setState(() {
        privateExpressionsActive = true;
        privateCollectionActive = false;
      });
    } else if (domain == 'collection') {
      setState(() {
        privateExpressionsActive = false;
        privateCollectionActive = true;
      });
    }
  }

  Widget _buildDenList() {
    if (publicExpressionsActive) {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: const <Widget>[SizedBox()],
      );
    } else if (publicCollectionActive == true) {
      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[DenCollectionPreview()],
      );
    } else {
      return const SizedBox();
    }
  }

  final List<String> _tabs = <String>['Open Den', 'Private Den'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            ValueListenableBuilder<UserProfile>(
              valueListenable: _profile,
              builder: (BuildContext context, UserProfile snapshot, _) {
                return _JuntoDenAppbar(
                  handle: snapshot.username,
                  name: '${snapshot.firstName} ${snapshot.lastName}',
                  profilePicture: profilePicture,
                  bio: snapshot.bio,
                );
              },
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelPadding: const EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: const Color(0xff333333),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff333333),
                  ),
                  indicatorWeight: 0.0001,
                  tabs: _tabs
                      .map((String name) => Container(
                          margin: const EdgeInsets.only(right: 24),
                          color: Colors.white,
                          child: Tab(
                            text: name,
                          )))
                      .toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: <Widget>[_buildOpenDen(), _buildPrivateDen()]),
      ),
    );
  }

  Widget _buildOpenDen() {
    if (publicExpressionsActive) {
      return ListView(
        children: <Widget>[
          _buildOpenDenToggle(),
          ExpressionPreview(
            expression: expressions[0],
          ),
          ExpressionPreview(
            expression: expressions[1],
          ),
          ExpressionPreview(
            expression: expressions[0],
          ),
          ExpressionPreview(
            expression: expressions[1],
          ),
        ],
      );
    } else if (publicCollectionActive) {
      return ListView(
        children: <Widget>[_buildOpenDenToggle(), _buildDenList()],
      );
    }
    return Container();
  }

  Widget _buildOpenDenToggle() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(2.5),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xffeeeeee),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _togglePublicDomain('expressions');
                      },
                      child: Container(
                        height: 30,
                        // half width of parent container minus horizontal padding
                        width: 37.5,
                        decoration: BoxDecoration(
                          color: publicExpressionsActive
                              ? Colors.white
                              : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          CustomIcons.half_lotus,
                          size: 12,
                          color: publicExpressionsActive
                              ? const Color(0xff555555)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _togglePublicDomain('collection');
                      },
                      child: Container(
                        height: 30,
                        // half width of parent container minus horizontal padding
                        width: 37.5,
                        decoration: BoxDecoration(
                          color: publicCollectionActive
                              ? Colors.white
                              : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.collections,
                          size: 12,
                          color: publicCollectionActive
                              ? const Color(0xff555555)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              publicCollectionActive
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                DenCreateCollection(),
                          ),
                        );
                      },
                      child: Container(
                        width: 38,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: const Color(0xff555555),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPrivateDen() {
    if (privateExpressionsActive) {
      return ListView(
        children: <Widget>[
          _buildPrivateDenToggle(),
          ExpressionPreview(
            expression: expressions[0],
          ),
          ExpressionPreview(
            expression: expressions[1],
          ),
          ExpressionPreview(
            expression: expressions[0],
          ),
          ExpressionPreview(
            expression: expressions[1],
          ),
        ],
      );
    } else if (privateCollectionActive) {
      return ListView(
        children: <Widget>[_buildPrivateDenToggle(), _buildDenList()],
      );
    }
    return Container();
  }

  Widget _buildPrivateDenToggle() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(2.5),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xffeeeeee),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _togglePrivateDomain('expressions');
                      },
                      child: Container(
                        height: 30,
                        // half width of parent container minus horizontal padding
                        width: 37.5,
                        decoration: BoxDecoration(
                          color: privateExpressionsActive
                              ? Colors.white
                              : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          CustomIcons.half_lotus,
                          size: 12,
                          color: privateExpressionsActive
                              ? const Color(0xff555555)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _togglePrivateDomain('collection');
                      },
                      child: Container(
                        height: 30,
                        // half width of parent container minus horizontal padding
                        width: 37.5,
                        decoration: BoxDecoration(
                          color: privateCollectionActive
                              ? Colors.white
                              : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.collections,
                          size: 12,
                          color: privateCollectionActive
                              ? const Color(0xff555555)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              privateCollectionActive
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                DenCreateCollection(),
                          ),
                        );
                      },
                      child: Container(
                        width: 38,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: const Color(0xff555555),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}

class _JuntoDenAppbar extends StatelessWidget {
  const _JuntoDenAppbar({
    Key key,
    @required this.handle,
    @required this.name,
    @required this.profilePicture,
    @required this.bio,
  }) : super(key: key);

  final String handle;
  final String name;
  final String profilePicture;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.light,
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Colors.white,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: <double>[
                      0.1,
                      0.9
                    ],
                    colors: <Color>[
                      JuntoPalette.juntoSecondary,
                      JuntoPalette.juntoPrimary
                    ]),
              ),
            ),
            Transform.translate(
              offset: const Offset(0.0, -18.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) => DenExpanded(
                                handle: handle,
                                name: name,
                                profilePicture: profilePicture,
                                bio: bio),
                          ),
                        );
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          border: Border.all(
                            width: 2.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0.0, 9.0),
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const Icon(CustomIcons.more, size: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0.0, -18.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bio,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/junto-mobile__location.png',
                                  height: 17,
                                  color: JuntoPalette.juntoSleek,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Spirit',
                                  style: TextStyle(
                                    color: JuntoPalette.juntoSleek,
                                  ),
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
                                  height: 17,
                                  color: JuntoPalette.juntoSleek,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'junto.foundation',
                                  style: TextStyle(
                                      color: JuntoPalette.juntoPrimary),
                                )
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height * .2 + 191,
      forceElevated: false,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + .5;

  @override
  double get maxExtent => _tabBar.preferredSize.height + .5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
