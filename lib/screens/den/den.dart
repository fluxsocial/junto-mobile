import 'package:async/async.dart' show AsyncMemoizer;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/mock/mock_expression.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/den_appbar_new.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
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
  List<CentralizedExpressionResponse> mockExpressions =
      MockExpressionService().collectiveExpressions;

  // ignore: unused_element
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
    return Scaffold(
        key: _juntoDenKey,
        appBar: DenAppbar(),
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

        // dynamically render body
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            controller: _denController,
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                //FIXME(Nash): Replace with dynamic server content.
                const JuntoDenSliverAppbar(
                  handle: 'sunyata',
                  name: 'Eric Yang',
                  profilePicture: 'assets/images/junto-mobile__eric.png',
                  bio: 'student of suffering and its cessation',
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
                      child: Text('student of suffering and its cessation',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                ),

                // public mock expressions
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.only(
                                left: 10, right: 5, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // even number indexes
                                ExpressionPreview(
                                    expression: mockExpressions[0]),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.only(
                                left: 5, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // odd number indexes
                                ExpressionPreview(
                                    expression: mockExpressions[0]),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // private mock expressions
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.only(
                                left: 10, right: 5, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // even number indexes
                                ExpressionPreview(
                                    expression: mockExpressions[0]),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.only(
                                left: 5, right: 10, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // odd number indexes
                                ExpressionPreview(
                                    expression: mockExpressions[0]),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // UserExpressions(
                //   key: const PageStorageKey<String>('public-user-expressions'),
                //   privacy: 'Public',
                //   userProfile: snapshot.data,
                // ),
                // UserExpressions(
                //   key: const PageStorageKey<String>('private-user-expressions'),
                //   privacy: 'Private',
                //   userProfile: snapshot.data,
                // )
              ],
            ),
          ),
        ));

    // final MediaQueryData media = MediaQuery.of(context);
    // return FutureBuilder<UserProfile>(
    //   future: _retrieveUserInfo(),
    //   builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
    //     if (!snapshot.hasData) {
    //       return Container(
    //         height: media.size.height,
    //         width: media.size.width,
    //         child: const Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //     if (snapshot.hasError) {
    //       return Container(
    //         height: media.size.height,
    //         width: media.size.width,
    //         child: Center(
    //           child: Text('Unable to load user ${snapshot.error}'),
    //         ),
    //       );
    //     }
    //     return DefaultTabController(
    //       length: _tabs.length,
    //       child: NestedScrollView(
    //         physics: const ClampingScrollPhysics(),
    //         headerSliverBuilder:
    //             (BuildContext context, bool innerBoxIsScrolled) {
    //           return <Widget>[
    //             JuntoDenAppbar(
    //               handle: snapshot.data.username,
    //               name: '${snapshot.data.firstName} ${snapshot.data.lastName}',
    //               profilePicture: profilePicture,
    //               bio: snapshot.data.bio,
    //             ),
    //             SliverPersistentHeader(
    //               delegate: JuntoAppBarDelegate(
    //                 TabBar(
    //                   labelPadding: const EdgeInsets.all(0),
    //                   isScrollable: true,
    //                   labelColor: Theme.of(context).primaryColorDark,
    //                   labelStyle: Theme.of(context).textTheme.subhead,
    //                   indicatorWeight: 0.0001,
    //                   tabs: <Widget>[
    //                     for (String name in _tabs)
    //                       Container(
    //                         margin: const EdgeInsets.only(right: 24),
    //                         color: Theme.of(context).colorScheme.background,
    //                         child: Tab(
    //                           text: name,
    //                         ),
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //               pinned: true,
    //             ),
    //           ];
    //         },
    //         body: TabBarView(
    //           children: <Widget>[
    //             ListView(
    //               physics: const ClampingScrollPhysics(),
    //               shrinkWrap: true,
    //               padding: const EdgeInsets.only(left: 10),
    //               children: <Widget>[
    //                 SizedBox(height: 5),
    //                 Container(
    //                   padding: const EdgeInsets.only(top: 5, bottom: 5),
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                         child: Row(
    //                           children: <Widget>[
    //                             Icon(CustomIcons.gender,
    //                                 size: 17,
    //                                 color: Theme.of(context).primaryColor),
    //                             const SizedBox(width: 5),
    //                             Text(
    //                               'he/him',
    //                               maxLines: 1,
    //                               overflow: TextOverflow.ellipsis,
    //                               style: TextStyle(
    //                                   color: Theme.of(context).primaryColor,
    //                                   fontSize: 15,
    //                                   fontWeight: FontWeight.w600),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),
    //                       Container(
    //                         child: Row(
    //                           children: <Widget>[
    //                             Image.asset(
    //                               'assets/images/junto-mobile__location.png',
    //                               height: 15,
    //                               color: Theme.of(context).primaryColor,
    //                             ),
    //                             const SizedBox(width: 5),
    //                             Text(
    //                               'Spirit',
    //                               maxLines: 1,
    //                               overflow: TextOverflow.ellipsis,
    //                               style: TextStyle(
    //                                   color: Theme.of(context).primaryColor,
    //                                   fontSize: 15,
    //                                   fontWeight: FontWeight.w600),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),
    //                       Container(
    //                         child: Row(
    //                           children: <Widget>[
    //                             Image.asset(
    //                               'assets/images/junto-mobile__link.png',
    //                               height: 15,
    //                               color: Theme.of(context).primaryColor,
    //                             ),
    //                             const SizedBox(width: 5),
    //                             Text(
    //                               'junto.foundation',
    //                               overflow: TextOverflow.ellipsis,
    //                               maxLines: 1,
    //                               style: TextStyle(
    //                                   color: Theme.of(context).primaryColor,
    //                                   fontSize: 15,
    //                                   fontWeight: FontWeight.w600),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(height: 15),
    //                 CarouselSlider(
    //                   viewportFraction: 1.0,
    //                   height: MediaQuery.of(context).size.width - 20,
    //                   enableInfiniteScroll: false,
    //                   items: <Widget>[
    //                     Container(
    //                       padding: EdgeInsets.only(right: 10),
    //                       width: MediaQuery.of(context).size.width,
    //                       child: Image.asset(
    //                           'assets/images/junto-mobile__eric.png',
    //                           fit: BoxFit.cover),
    //                     ),
    //                     Container(
    //                       width: MediaQuery.of(context).size.width,
    //                       padding: EdgeInsets.only(right: 10),
    //                       child: Image.asset(
    //                           'assets/images/junto-mobile__eric--qigong.png',
    //                           fit: BoxFit.cover),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 15),
    //                 Container(
    //                   child: Text("student of suffering and its cessation",
    //                       style: Theme.of(context).textTheme.caption),
    //                 ),
    //               ],
    //             ),
    //             // public mock expressions
    //             ListView(
    //               shrinkWrap: true,
    //               physics: ClampingScrollPhysics(),
    //               children: <Widget>[
    //                 ExpressionPreview(expression: mockExpressions[0])
    //               ],
    //             ),

    //             // private mock expressions
    //             ListView(
    //               shrinkWrap: true,
    //               physics: ClampingScrollPhysics(),
    //               children: <Widget>[
    //                 ExpressionPreview(expression: mockExpressions[0])
    //               ],
    //             ),
    //             // UserExpressions(
    //             //   key: const PageStorageKey<String>('public-user-expressions'),
    //             //   privacy: 'Public',
    //             //   userProfile: snapshot.data,
    //             // ),
    //             // UserExpressions(
    //             //   key: const PageStorageKey<String>('private-user-expressions'),
    //             //   privacy: 'Private',
    //             //   userProfile: snapshot.data,
    //             // )
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

/// Linear list of expressions created by the given [userProfile].
class UserExpressions extends StatefulWidget {
  const UserExpressions({
    Key key,
    @required this.userProfile,
    @required this.privacy,
  }) : super(key: key);

  /// [UserProfile] of the user
  final UserProfile userProfile;

  /// Either Public or Private;
  final String privacy;

  @override
  _UserExpressionsState createState() => _UserExpressionsState();
}

class _UserExpressionsState extends State<UserExpressions> {
  UserRepo _userProvider;
  AsyncMemoizer<List<CentralizedExpressionResponse>> memoizer =
      AsyncMemoizer<List<CentralizedExpressionResponse>>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<List<CentralizedExpressionResponse>> getExpressions() {
    return memoizer.runOnce(
        () => _userProvider.getUsersExpressions(widget.userProfile.address));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return FutureBuilder<List<CentralizedExpressionResponse>>(
      future: getExpressions(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot) {
        if (snapshot.hasData) {
          final List<CentralizedExpressionResponse> _data = snapshot.data
              .where((CentralizedExpressionResponse expression) =>
                  expression.privacy == widget.privacy)
              .toList(growable: false);
          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpressionPreview(
                expression: _data[index],
              );
            },
          );
        }
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
    );
  }
}
