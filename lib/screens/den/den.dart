import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/den/den_collection_preview.dart';
import 'package:junto_beta_mobile/screens/den/den_create_collection.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/junto_app_delegate.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart' show AsyncMemoizer;

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> {
  String profilePicture = 'assets/images/junto-mobile__eric.png';
  final ValueNotifier<UserProfile> _profile =
      ValueNotifier<UserProfile>(UserProfile(username: '', bio: '', firstName: '', lastName: ''));
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
    expressions = Provider.of<CollectiveProvider>(context).collectiveExpressions;
  }

  Future<void> _retrieveUserInfo() async {
    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    final UserProfile _results = await userMemoizer.runOnce(() => _userProvider.readLocalUser());
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
                return JuntoDenAppbar(
                  handle: snapshot.username,
                  name: '${snapshot.firstName} ${snapshot.lastName}',
                  profilePicture: profilePicture,
                  bio: snapshot.bio,
                );
              },
            ),
            SliverPersistentHeader(
              delegate: JuntoAppBarDelegate(
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
          children: <Widget>[
            ValueListenableBuilder<UserProfile>(
              valueListenable: _profile,
              builder: (BuildContext context, UserProfile snapshot, _) {
                return PrivateUserEpxression(
                  userProfile: snapshot,
                );
              },
            ),
            // _buildOpenDen(),
            _buildPrivateDen(),
          ],
        ),
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
                          color: publicExpressionsActive ? Colors.white : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          CustomIcons.half_lotus,
                          size: 12,
                          color: publicExpressionsActive ? const Color(0xff555555) : const Color(0xff999999),
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
                          color: publicCollectionActive ? Colors.white : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.collections,
                          size: 12,
                          color: publicCollectionActive ? const Color(0xff555555) : const Color(0xff999999),
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
                            builder: (BuildContext context) => DenCreateCollection(),
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
                          color: privateExpressionsActive ? Colors.white : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          CustomIcons.half_lotus,
                          size: 12,
                          color: privateExpressionsActive ? const Color(0xff555555) : const Color(0xff999999),
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
                          color: privateCollectionActive ? Colors.white : const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.collections,
                          size: 12,
                          color: privateCollectionActive ? const Color(0xff555555) : const Color(0xff999999),
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
                            builder: (BuildContext context) => DenCreateCollection(),
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

class PrivateUserEpxression extends StatefulWidget {
  const PrivateUserEpxression({Key key, this.userProfile}) : super(key: key);
  final UserProfile userProfile;

  @override
  _PrivateUserEpxressionState createState() => _PrivateUserEpxressionState();
}

class _PrivateUserEpxressionState extends State<PrivateUserEpxression> {
  UserProvider _userProvider;
  AsyncMemoizer<List<CentralizedExpressionResponse>> memoizer = AsyncMemoizer<List<CentralizedExpressionResponse>>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  Future<List<CentralizedExpressionResponse>> getExpressions() {
    return memoizer.runOnce(() => _userProvider.getUsersExpressions('85235b21-1725-4e89-b6fa-305df7978e52'));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return FutureBuilder<List<CentralizedExpressionResponse>>(
      future: getExpressions(),
      builder: (BuildContext context, AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpressionPreview(
                expression: snapshot.data[index],
              );
            },
          );
        }
        if (snapshot.hasError) {
          return Container(
            height: media.size.height,
            width: media.size.width,
            child: const Center(
              child: Text('Error occured :('),
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
