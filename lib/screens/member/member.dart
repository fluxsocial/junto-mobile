import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_relationships.dart';
import 'package:junto_beta_mobile/screens/member/member_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar_name.dart';
import 'package:provider/provider.dart';

class JuntoMember extends StatefulWidget {
  const JuntoMember({
    Key key,
    @required this.profile,
  }) : super(key: key);

  static Route<dynamic> route(UserProfile profile) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoMember(
          profile: profile,
        );
      },
    );
  }

  final UserProfile profile;

  @override
  _JuntoMemberState createState() => _JuntoMemberState();
}

class _JuntoMemberState extends State<JuntoMember>
    with HideFab, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = [
    'Collective',
    'Feedback',
  ];
  UserData _memberProfile;
  String _userAddress;
  UserData _userProfile;
  UserRepo userProvider;
  GroupRepo groupProvider;
  bool isConnected;
  bool isFollowing;
  bool isFollowed;
  bool hasPendingConnection;
  bool hasPendingPackRequest;
  bool isPackMember;

  bool memberRelationshipsVisible = false;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _memberProfile = UserData(
      user: widget.profile,
      pack: null,
      connectionPerspective: null,
      userPerspective: null,
      privateDen: null,
      publicDen: null,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    setState(() {
      _userAddress = Provider.of<UserDataProvider>(context).userAddress;
      _userProfile = Provider.of<UserDataProvider>(context).userProfile;
      userProvider = Provider.of<UserRepo>(context, listen: false);
      groupProvider = Provider.of<GroupRepo>(context, listen: false);
    });

    // // see if user is connected to member
    await userProvider
        .isRelated(_userAddress, widget.profile.address)
        .then((Map<String, dynamic> result) {
      setState(() {
        isConnected = result['is_connected'];
        isFollowing = result['is_following'];
        isFollowed = result['is_followed'];
        hasPendingConnection = result['has_pending_connection'];
        hasPendingPackRequest = result['has_pending_pack_request'];
        isPackMember = result['is_pack_member'];
      });
    });
  }

  Future<void> refreshRelations() async {
    await userProvider
        .isRelated(_userAddress, widget.profile.address)
        .then((Map<String, dynamic> result) {
      setState(() {
        isConnected = result['is_connected'];
        isFollowing = result['is_following'];
        isFollowed = result['is_followed'];
        hasPendingConnection = result['has_pending_connection'];
        hasPendingPackRequest = result['has_pending_pack_request'];
        isPackMember = result['is_pack_member'];
      });
    });
  }

  void toggleMemberRelationships() {
    if (memberRelationshipsVisible) {
      setState(() {
        memberRelationshipsVisible = false;
      });
    } else if (!memberRelationshipsVisible) {
      setState(() {
        memberRelationshipsVisible = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (value) => hideOrShowFab(value, _isVisible),
      child: Scaffold(
        //TODO(dominik/Nash): revert filter drawer
        // and use bloc to fetch member expressions
        body: Container(
          child: Stack(
            children: <Widget>[
              Scaffold(
                key: scaffoldKey,
                body: DefaultTabController(
                  length: _tabs.length,
                  child: NestedScrollView(
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverPersistentHeader(
                          delegate: MemberAppbar(
                            expandedHeight:
                                MediaQuery.of(context).size.height * .1,
                            username: _memberProfile.user.username,
                          ),
                          floating: true,
                          pinned: true,
                        ),
                        MemberDenAppbar(
                          profile: widget.profile,
                          isConnected: isConnected,
                          toggleMemberRelationships: toggleMemberRelationships,
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: JuntoAppBarDelegate(
                            TabBar(
                              labelPadding: const EdgeInsets.all(0),
                              isScrollable: true,
                              labelColor: Theme.of(context).primaryColorDark,
                              unselectedLabelColor:
                                  Theme.of(context).primaryColorLight,
                              labelStyle: Theme.of(context).textTheme.subtitle1,
                              indicatorWeight: 0.0001,
                              tabs: <Widget>[
                                for (String name in _tabs)
                                  TabBarName(name: name),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: <Widget>[
                        UserExpressProvider(
                          address: widget.profile.address,
                          child: UserExpressions(
                            privacy: 'Public',
                            userProfile: widget.profile,
                            rootExpressions: true,
                            subExpressions: false,
                            communityCenterFeedback: false,
                          ),
                        ),
                        UserExpressProvider(
                          address: widget.profile.address,
                          child: UserExpressions(
                            privacy: 'Public',
                            userProfile: widget.profile,
                            rootExpressions: true,
                            subExpressions: false,
                            communityCenterFeedback: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: memberRelationshipsVisible ? 1.0 : 0.0,
                child: Visibility(
                  visible: memberRelationshipsVisible,
                  child: MemberRelationships(
                    isFollowing: isFollowing,
                    isConnected: isConnected,
                    hasPendingConnection: hasPendingConnection,
                    hasPendingPackRequest: hasPendingPackRequest,
                    isPackMember: isPackMember,
                    userProvider: userProvider,
                    memberProfile: widget.profile,
                    userProfile: _userProfile,
                    toggleMemberRelationships: toggleMemberRelationships,
                    refreshRelations: refreshRelations,
                    groupProvider: groupProvider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserExpressProvider extends StatelessWidget {
  final String address;
  final Widget child;

  const UserExpressProvider({
    Key key,
    @required this.address,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DenBloc>(
            create: (context) => DenBloc(
                  Provider.of<UserRepo>(context, listen: false),
                  Provider.of<UserDataProvider>(context, listen: false),
                  Provider.of<ExpressionRepo>(context, listen: false),
                )),
      ],
      child: child,
    );
  }
}
