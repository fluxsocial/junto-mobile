import 'dart:async';
import 'dart:convert';

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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  UserData _memberProfile;
  String _userAddress;
  UserData _userProfile;
  UserRepo userProvider;
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
      userProvider = Provider.of<UserRepo>(context, listen: false);
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
      child: BlocProvider(
        create: (context) => DenBloc(
          Provider.of<UserRepo>(context, listen: false),
          Provider.of<UserDataProvider>(context, listen: false),
        )..add(
            LoadDen(widget.profile.address),
          ),
        child: Scaffold(
          //TODO(dominik/Nash): revert filter drawer
          // and use bloc to fetch member expressions
          body: Container(
            child: Stack(
              children: <Widget>[
                Scaffold(
                  key: scaffoldKey,
                  body: NestedScrollView(
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
                          pinned: false,
                        ),
                        MemberDenAppbar(
                          profile: widget.profile,
                          isConnected: isConnected,
                          toggleMemberRelationships: toggleMemberRelationships,
                        ),
                      ];
                    },
                    body: UserExpressions(
                      key: UniqueKey(),
                      privacy: 'Public',
                      userProfile: widget.profile,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
