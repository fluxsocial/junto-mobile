import 'dart:async';
import 'package:async/async.dart' show AsyncMemoizer;

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';

class JuntoRelationships extends StatefulWidget {
  JuntoRelationships(this.userAddress, this.userFollowPerspectiveAddress);

  final String userAddress;
  final String userFollowPerspectiveAddress;

  @override
  State<StatefulWidget> createState() {
    return JuntoRelationshipsState();
  }
}

class JuntoRelationshipsState extends State<JuntoRelationships> {
  final List<String> _tabs = <String>[
    'Connections',
    'Subscriptions',
    // 'Subscribers',
    'Pending'
  ];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future getUserRelationships() async {
    return _memoizer.runOnce(
      () => Provider.of<UserRepo>(context).userRelations(),
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
                      color: Theme.of(context).dividerColor, width: .75),
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
                    labelStyle: Theme.of(context).textTheme.subtitle1,
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
          body: FutureBuilder(
            future: getUserRelationships(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // get list of connections
                final List<UserProfile> _connectionsMembers =
                    snapshot.data['connections']['results'];

                // get list of following
                final List<UserProfile> _followingMembers =
                    snapshot.data['following']['results'];

                // get list of pending connections
                final List<UserProfile> _pendingConnectionsMembers =
                    snapshot.data['pending_connections']['results'];

                return TabBarView(
                  children: <Widget>[
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

                    // subscriptions
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _followingMembers
                          .map(
                            (dynamic connection) =>
                                MemberPreview(profile: connection),
                          )
                          .toList(),
                    ),
                    // pending connections
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _pendingConnectionsMembers
                          .map(
                            (dynamic connection) =>
                                RelationshipRequest(connection),
                          )
                          .toList(),
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                // print(snapshot.error);
                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: Text('Hmmm, something is up',
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: Text('Hmmm, something is up',
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: Text('Hmmm, something is up',
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ),
                  ],
                );
              }
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator()),
                  ),
                  Center(
                    child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator()),
                  ),
                  Center(
                    child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator()),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
