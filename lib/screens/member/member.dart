import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_relationships.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/user_expressions.dart';
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
                  _MemberDenAppbar(
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
                                      color: Theme.of(context).primaryColor),
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
                            if (widget.profile.gender.isNotEmpty &&
                                widget.profile.gender[0].isNotEmpty)
                              _ProfileDetails(
                                iconData: CustomIcons.gender,
                                item: widget.profile.gender,
                              ),
                            if (widget.profile.location.isNotEmpty &&
                                widget.profile.location[0].isNotEmpty)
                              _ProfileDetails(
                                imageUri:
                                    'assets/images/junto-mobile__location.png',
                                item: widget.profile.location,
                              ),
                            if (widget.profile.website.isNotEmpty &&
                                widget.profile.website[0].isNotEmpty)
                              _ProfileDetails(
                                imageUri:
                                    'assets/images/junto-mobile__link.png',
                                item: widget.profile.website,
                              )
                          ],
                        ),
                      ),
                      Container(
                        child: Text(widget.profile.bio,
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ],
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
                refreshRelations: refreshRelations),
          ),
        ),
      ],
    );
  }
}

/// Used to display the user's location, gender and website. Image and Icon data
/// cannot be supplied at the same time.
class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    Key key,
    @required this.item,
    this.iconData,
    this.imageUri,
  }) : super(key: key);

  final List<String> item;
  final IconData iconData;
  final String imageUri;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          if (imageUri != null)
            Image.asset(
              imageUri,
              height: 15,
              color: Theme.of(context).primaryColor,
            ),
          if (iconData != null)
            Icon(CustomIcons.gender,
                size: 17, color: Theme.of(context).primaryColor),
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
  }
}

class _MemberDenAppbar extends StatefulWidget {
  const _MemberDenAppbar(
      {Key key,
      @required this.profile,
      @required this.isConnected,
      @required this.toggleMemberRelationships,
      this.isFollowing})
      : super(key: key);

  final UserProfile profile;
  final bool isConnected;
  final bool isFollowing;
  final Function toggleMemberRelationships;

  @override
  State<StatefulWidget> createState() {
    return _MemberDenAppbarState();
  }
}

class _MemberDenAppbarState extends State<_MemberDenAppbar> {
  final GlobalKey<_MemberDenAppbarState> _keyFlexibleSpace =
      GlobalKey<_MemberDenAppbarState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  double _flexibleHeightSpace;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  Widget _displayRelationshipIndicator(BuildContext context) {
    if (widget.isFollowing == true && widget.isConnected == false) {
      return Icon(CustomIcons.groups,
          size: 17, color: Theme.of(context).primaryColor);
    } else if (widget.isFollowing == true && widget.isConnected == true) {
      return Icon(CustomIcons.pawprints,
          size: 17, color: Theme.of(context).primaryColor);
    } else if (widget.isFollowing == false && widget.isConnected == false) {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).primaryColor);
    } else {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.light,
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Theme.of(context).colorScheme.background,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const <double>[0.1, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondaryVariant,
                          Theme.of(context).colorScheme.primaryVariant,
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                  ),
                  Container(
                    key: _keyFlexibleSpace,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.profile.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              widget.toggleMemberRelationships();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 14),
                                  _displayRelationshipIndicator(context),
                                  const SizedBox(width: 2),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 12,
                                      color: Theme.of(context).primaryColor)
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .2 - 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CachedNetworkImage(
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          height: 60,
                          width: 60,
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
                      imageUrl: widget.profile.profilePicture[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      expandedHeight: _flexibleHeightSpace == null
          ? 1000
          : _flexibleHeightSpace + MediaQuery.of(context).size.height * .2,
      forceElevated: false,
    );
  }
}
