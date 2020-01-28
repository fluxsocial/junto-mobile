import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/user_expressions.dart';
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

class _JuntoMemberState extends State<JuntoMember> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = <String>['About', 'Expressions'];
  String _userAddress;
  UserRepo userProvider;
  bool isConnected;
  bool isFollowing;

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

    setState(() {
      _userAddress = prefs.getString('user_id');
      userProvider = Provider.of<UserRepo>(context, listen: false);
    });

    // // see if user is connected to member
    await userProvider
        .isConnected(_userAddress, widget.profile.address)
        .then((bool result) {
      print(result);
      setState(() {
        isConnected = result;
      });
    });

    // see if user is following member
    await userProvider
        .isFollowing(_userAddress, widget.profile.address)
        .then((bool result) {
      setState(() {
        isFollowing = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: MemberAppbar(widget.profile.username),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _MemberDenAppbar(
                profile: widget.profile,
                isConnected: isConnected,
              ),
              SliverPersistentHeader(
                delegate: JuntoAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColor,
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
                        widget.profile.gender[0] != ' '
                            ? _ProfileDetails(
                                iconData: CustomIcons.gender,
                                item: widget.profile.gender,
                                placeholderText: 'Gender',
                              )
                            : const SizedBox(),
                        widget.profile.location[0] != ' '
                            ? _ProfileDetails(
                                imageUri:
                                    'assets/images/junto-mobile__location.png',
                                item: widget.profile.location,
                                placeholderText: 'Location',
                              )
                            : const SizedBox(),
                        widget.profile.website[0] != ' '
                            ? _ProfileDetails(
                                imageUri:
                                    'assets/images/junto-mobile__link.png',
                                item: widget.profile.website,
                                placeholderText: 'Website',
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  CarouselSlider(
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.width - 20,
                    enableInfiniteScroll: false,
                    items: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                            'assets/images/junto-mobile__mockprofpic--one.png',
                            fit: BoxFit.cover),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                            'assets/images/junto-mobile__mockprofpic--two.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
    );
  }
}

/// Used to display the user's location, gender and website. Image and Icon data
/// cannot be supplied at the same time.
class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    Key key,
    @required this.item,
    @required this.placeholderText,
    this.iconData,
    this.imageUri,
  }) : super(key: key);

  final List<String> item;
  final String placeholderText;
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
          if (item.isNotEmpty)
            Text(
              item.first ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          if (item.isEmpty)
            Text(
              placeholderText,
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

/// Custom [SliverPersistentHeaderDelegate] used on Den.
class JuntoAppBarDelegate extends SliverPersistentHeaderDelegate {
  JuntoAppBarDelegate(this._tabBar);

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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(JuntoAppBarDelegate oldDelegate) {
    return false;
  }
}

class MemberRelationshipsModal extends StatelessWidget {
  const MemberRelationshipsModal({
    Key key,
    @required this.onConnectTap,
  }) : super(key: key);
  final VoidCallback onConnectTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .36,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Icon(
                      CustomIcons.pawprints,
                      size: 17,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Subscribe',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: onConnectTap,
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Icon(
                      CustomIcons.circle,
                      size: 17,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Connect',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Icon(
                      CustomIcons.packs,
                      size: 17,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Invite to my pack',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberDenAppbar extends StatelessWidget {
  const _MemberDenAppbar(
      {Key key,
      @required this.profile,
      @required this.isConnected,
      this.isFollowing})
      : super(key: key);

  final UserProfile profile;
  final bool isConnected;
  final bool isFollowing;

  Future<void> _connectWithUser(BuildContext context) async {
    final UserRepo _userRepo = Provider.of<UserRepo>(context, listen: false);
    try {
      JuntoLoader.showLoader(context);
      await _userRepo.connectUser(profile.address);
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(context, 'Connection Sent', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
          context, 'Error occured ${error?.message}', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    }
  }

  Widget _displayRelationshipIndicator(BuildContext context) {
    if (isFollowing == true && isConnected == false) {
      return Icon(CustomIcons.groups, size: 17, color: Colors.white);
    } else if (isFollowing == true && isConnected == true) {
      return Icon(CustomIcons.pawprints, size: 17, color: Colors.white);
    } else if (isFollowing == false && isConnected == false) {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).colorScheme.onPrimary);
    } else {
      return Image.asset('assets/images/junto-mobile__infinity.png',
          height: 14, color: Theme.of(context).colorScheme.onPrimary);
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
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .24,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              color: Colors.transparent,
                              child: MemberRelationshipsModal(
                                onConnectTap: () => _connectWithUser(context),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height * .24,
      forceElevated: false,
    );
  }
}
