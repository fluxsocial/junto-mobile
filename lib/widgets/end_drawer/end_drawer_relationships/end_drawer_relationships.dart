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
                print(snapshot.data);
                final List<dynamic> _subscriptionsResults =
                    snapshot.data['following']['results'];

                final List<dynamic> _connectionsResults =
                    snapshot.data['connections']['results'];

                final List<dynamic> _pendingConnectionsResults =
                    snapshot.data['pending_connections']['results'];

                final List<dynamic> _connections = <dynamic>[];
                final List<dynamic> _subscriptions = <dynamic>[];
                final List<dynamic> _pendingConnections = <dynamic>[];

                if (_connectionsResults.isNotEmpty) {
                  for (final dynamic result in _connectionsResults) {
                    _connections.add(
                      UserProfile.fromMap(result),
                    );
                  }
                }

                if (_subscriptionsResults.isNotEmpty) {
                  for (final dynamic result in _subscriptionsResults) {
                    _subscriptions.add(
                      UserProfile.fromMap(result),
                    );
                  }
                }

                for (final dynamic result in _pendingConnectionsResults) {
                  _pendingConnections.add(
                    UserProfile.fromMap(result),
                  );
                }

                return TabBarView(
                  children: <Widget>[
                    // connections
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _connections
                          .map(
                            (dynamic connection) =>
                                MemberPreview(profile: connection),
                          )
                          .toList(),
                    ),

                    // subscriptions
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _subscriptions
                          .map(
                            (dynamic connection) =>
                                MemberPreview(profile: connection),
                          )
                          .toList(),
                    ),
                    // pending connections
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: _pendingConnections
                          .map(
                            (dynamic connection) =>
                                MemberPreview(profile: connection),
                          )
                          .toList(),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                // print(snapshot.error);
                return TabBarView(
                  children: <Widget>[
                    Text(
                      snapshot.error.toString(),
                    ),
                    Text('or'),
                    Text('oops'),
                  ],
                );
              }
              return const Text('what is good');
            },
          ),
        ),
      ),
    );
  }
}
