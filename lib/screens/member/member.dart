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
  bool hasPendingConnection;
  bool hasPendingPackRequest;
  bool isPackMember;

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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: MemberAppbar(widget.profile.username),
          ),
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
    );
  }
}
