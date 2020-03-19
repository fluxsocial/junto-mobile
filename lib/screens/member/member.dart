import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_relationships.dart';
import 'package:junto_beta_mobile/screens/member/member_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

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
  ScrollController _memberController;

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
    _memberController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _memberController.addListener(_onScrollingHasChanged);
      if (_memberController.hasClients)
        _memberController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
    _addPostFrameCallback();
  }

  void _addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _memberController.addListener(_onScrollingHasChanged);
      if (_memberController.hasClients)
        _memberController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_memberController, _isVisible);
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
    _memberController.removeListener(_onScrollingHasChanged);
    _memberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: FilterDrawerContent(
          filterByChannel: null,
          channels: [],
          resetChannels: () {},
        ),
        rightMenu: JuntoDrawer(),
        scaffold: Stack(
          children: <Widget>[
            Scaffold(
              key: scaffoldKey,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: MemberAppbar(widget.profile.username),
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
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: BottomNav(
                    actionsVisible: false,
                    onLeftButtonTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<dynamic>(
                          builder: (BuildContext context) => AboutMember(
                            profile: _memberProfile,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              body: NestedScrollView(
                physics: const ClampingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    MemberDenAppbar(
                      profile: widget.profile,
                      isConnected: isConnected,
                      toggleMemberRelationships: toggleMemberRelationships,
                    ),
                  ];
                },
                body: UserExpressions(
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
    );
  }
}
