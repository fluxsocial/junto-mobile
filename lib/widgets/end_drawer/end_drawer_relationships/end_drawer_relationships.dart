import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pending/pending_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/subscriptions.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/subscribers.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/connections.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pack_members.dart';
import 'package:provider/provider.dart';

class JuntoRelationships extends StatefulWidget {
  const JuntoRelationships(this.userAddress, this.userFollowPerspectiveAddress);

  final String userAddress;
  final String userFollowPerspectiveAddress;

  @override
  State<StatefulWidget> createState() {
    return JuntoRelationshipsState();
  }
}

class JuntoRelationshipsState extends State<JuntoRelationships> {
  Future<dynamic> _userRelations;
  List<UserProfile> pendingConnectionRequests;
  List<UserProfile> pendingPackRequests;

  final List<String> _tabs = <String>[
    'SUBSCRIPTIONS',
    'SUBSCRIBERS',
    'CONNECTIONS',
    'PACK',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userRelations = getUserRelationships();
  }

  Future<dynamic> getUserRelationships() async {
    final dynamic userRelations =
        await Provider.of<UserRepo>(context, listen: false).userRelations();
    setState(() {
      pendingConnectionRequests =
          userRelations['pending_connections']['results'];
      pendingPackRequests =
          userRelations['pending_group_join_requests']['results'];
    });

    return userRelations;
  }

  void _refreshActions(bool action) {
    setState(() {
      _userRelations = getUserRelationships();
    });
  }

  Widget _notificationSignal() {
    return Positioned(
      top: 10,
      right: 5,
      child: Container(
        height: 7,
        width: 7,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => PendingRelationships(
                          userAddress: widget.userAddress,
                          refreshActions: _refreshActions,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 42,
                          width: 42,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            CustomIcons.request,
                            color: Theme.of(context).primaryColorDark,
                            size: 17,
                          ),
                        ),
                        if (pendingConnectionRequests != null &&
                            pendingPackRequests != null)
                          if (pendingConnectionRequests.isNotEmpty ||
                              pendingPackRequests.isNotEmpty)
                            _notificationSignal()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
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
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              // subscriptions
              Subscriptions(),

              // subscribers
              Subscribers(),

              // connections
              Connections(),

              // pack members
              PackMembers(userAddress: widget.userAddress),
            ],
          ),
        ),
      ),
    );
  }
}
