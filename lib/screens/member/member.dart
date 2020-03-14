import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_about.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_relationships.dart';
import 'package:junto_beta_mobile/screens/member/member_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
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

class _JuntoMemberState extends State<JuntoMember> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = <String>['ABOUT', 'EXPRESSIONS'];
  String _userAddress;
  UserData _userProfile;
  UserRepo userProvider;
  bool isConnected;
  bool isFollowing;
  bool isFollowed;
  bool isPending;

  bool memberRelationshipsVisible = false;

  @override
  void initState() {
    super.initState();
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
      print(result);
      setState(() {
        isConnected = result['is_connected'];
        isFollowing = result['is_following'];
        isFollowed = result['is_followed'];
        isPending = result['has_pending_connection'];
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
        isPending = result['has_pending_connection'];
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: MemberAppbar(widget.profile.username),
          ),
          body: DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  MemberDenAppbar(
                    profile: widget.profile,
                    isConnected: isConnected,
                    toggleMemberRelationships: toggleMemberRelationships,
                  ),
                  SliverPersistentHeader(
                    delegate: JuntoAppBarDelegate(
                      TabBar(
                        labelPadding: const EdgeInsets.all(0),
                        isScrollable: true,
                        labelColor: Theme.of(context).primaryColor,
                        labelStyle: Theme.of(context).textTheme.subtitle1,
                        indicatorWeight: 0.0001,
                        tabs: <Widget>[
                          for (String name in _tabs)
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              color: Theme.of(context).colorScheme.background,
                              child: Tab(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
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
              body: TabBarView(
                children: <Widget>[
                  JuntoMemberAbout(
                    gender: widget.profile.gender,
                    location: widget.profile.location,
                    website: widget.profile.website,
                    bio: widget.profile.bio,
                  ),
                  UserExpressions(
                    privacy: 'Public',
                    userProfile: widget.profile,
                  )
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
              isPending: isPending,
              userProvider: userProvider,
              memberProfile: widget.profile,
              userProfile: _userProfile,
              toggleMemberRelationships: toggleMemberRelationships,
              refreshRelations: refreshRelations,
            ),
          ),
        ),
      ],
    );
  }
}
