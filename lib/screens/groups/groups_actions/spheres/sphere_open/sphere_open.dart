import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_about.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    @required this.group,
    @required this.channels,
  }) : super(key: key);

  final Group group;
  final List<String> channels;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  final GlobalKey<SphereOpenState> _keyFlexibleSpace =
      GlobalKey<SphereOpenState>();

  String _userAddress;
  UserData _userProfile;
  double _flexibleHeightSpace;
  final List<String> _tabs = <String>['ABOUT', 'EXPRESSIONS'];
  final ValueNotifier<bool> shouldRefresh = ValueNotifier<bool>(true);
  Map<String, dynamic> relationToGroup;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(
      prefs.getString('user_data'),
    );
    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });

    final Map<String, dynamic> _relationToGroup =
        await Provider.of<GroupRepo>(context, listen: false)
            .getRelationToGroup(widget.group.address, _userAddress);
    setState(() {
      relationToGroup = _relationToGroup;
    });
    print(relationToGroup);
  }

  Future<List<Users>> _getMembers() async {
    return Provider.of<GroupRepo>(context, listen: false)
        .getGroupMembers(widget.group.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
            group: widget.group,
            relationToGroup: relationToGroup,
            userAddress: _userAddress),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              SphereOpenAbout(
                getMembers: _getMembers(),
                group: widget.group,
              ),
              if (widget.group.address != null)
                GroupExpressions(
                  key: ValueKey<String>(widget.group.address),
                  group: widget.group,
                  userAddress: _userAddress,
                  expressionsPrivacy: 'Public',
                  shouldRefresh: shouldRefresh,
                  channels: widget.channels,
                )
            ],
          ),
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                automaticallyImplyLeading: false,
                primary: false,
                actions: const <Widget>[
                  SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ],
                backgroundColor: Theme.of(context).colorScheme.background,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: <Widget>[
                      widget.group.groupData.photo == ''
                          ? Container(
                              height: MediaQuery.of(context).size.height * .3,
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
                              alignment: Alignment.center,
                              child: Icon(
                                CustomIcons.spheres,
                                size: 60,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.group.groupData.photo,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .3,
                              placeholder: (BuildContext context, String _) {
                                return Container(
                                  color: Theme.of(context).dividerColor,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                );
                              },
                              fit: BoxFit.cover),
                      Container(
                        key: _keyFlexibleSpace,
                        padding: const EdgeInsets.symmetric(
                            horizontal: JuntoStyles.horizontalPadding,
                            vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.group.groupData.name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            relationToGroup != null &&
                                    !relationToGroup['creator'] &&
                                    !relationToGroup['member'] &&
                                    !relationToGroup['facilitator']
                                ? _joinGroup()
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                expandedHeight: _flexibleHeightSpace == null
                    ? 10000
                    : MediaQuery.of(context).size.height * .3 +
                        _flexibleHeightSpace,
                forceElevated: false,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: JuntoAppBarDelegate(
                  TabBar(
                    labelPadding: const EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColorDark,
                    unselectedLabelColor: Theme.of(context).primaryColorLight,
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
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ];
          },
        ),
      ),
    );
  }

  Widget _joinGroup() {
    return GestureDetector(
      onTap: () {
        Provider.of<GroupRepo>(context, listen: false).addGroupMember(
          widget.group.address,
          <UserProfile>[_userProfile.user],
          'Member',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          'JOiN',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
