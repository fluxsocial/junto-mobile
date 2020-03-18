import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
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
    return Provider.of<UserRepo>(context, listen: false).userRelations();
  }

  void _refreshActions(bool action) {
    setState(() {
      _userRelations = getUserRelationships();
    });
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
          body: FutureBuilder<dynamic>(
            future: _userRelations,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                // get list of connections
                final List<UserProfile> _connectionsMembers =
                    snapshot.data['connections']['results'];

                // get list of following
                final List<UserProfile> _subscriptionMembers =
                    snapshot.data['following']['results'];

                final List<UserProfile> _subscriberMembers =
                    snapshot.data['followers']['results'];

                // set state for pending connection and pack requests
                // setState(() {
                //   pendingConnectionRequests =
                //       snapshot.data['pending_connections']['results'];
                //   // pendingPackRequests =
                //   //     snapshot.data['pending_group_joins']['results'];
                // });

                return TabBarView(
                  children: <Widget>[
                    // subscriptions
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _subscriptionMembers
                          .map(
                            (dynamic subscription) =>
                                MemberPreview(profile: subscription),
                          )
                          .toList(),
                    ),

                    // subscribers
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _subscriberMembers
                          .map(
                            (dynamic subscriber) =>
                                MemberPreview(profile: subscriber),
                          )
                          .toList(),
                    ),

                    // connections
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _connectionsMembers
                          .map(
                            (dynamic connection) =>
                                MemberPreview(profile: connection),
                          )
                          .toList(),
                    ),

                    // todo: waiting on API - return pack members
                    const SizedBox()
                  ],
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                    Center(
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                    Center(
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                    Center(
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                );
              }
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                  Center(
                    child: JuntoProgressIndicator(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
