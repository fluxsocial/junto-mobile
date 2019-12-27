import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';

class JuntoRelationships extends StatelessWidget {
  JuntoRelationships(this.userAddress, this.userFollowPerspectiveAddress);
  final String userAddress;
  final String userFollowPerspectiveAddress;

  final List<String> _tabs = <String>[
    'Connections',
    'Subscriptions',
    // 'Subscribers',
    'Pending'
  ];

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
                Text('Relationships',
                    style: Theme.of(context).textTheme.subhead),
                const SizedBox(width: 42)
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
              _displayConnections(context, userAddress),
              _displaySubscriptions(context, userFollowPerspectiveAddress),
              _displayPending(context, userAddress)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayConnections(BuildContext context, String userAddress) {
    return FutureBuilder<List<UserProfile>>(
      future: Provider.of<UserRepo>(context).connectedUsers(userAddress),
      builder:
          (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: Text('No connections!',
                    style: Theme.of(context).textTheme.headline),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final UserProfile data = snapshot.data[index];
              return const SizedBox();
              // return MemberPreview(profile: data);
            },
          );
        } else if (snapshot.hasError) {
          Container(
            child: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        return ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 120,
            child: Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: JuntoProgressIndicator(),
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _displaySubscriptions(
      BuildContext context, String userFollowPerspectiveAddress) {
    return FutureBuilder<List<UserProfile>>(
      future: Provider.of<UserRepo>(context)
          .getPerspectiveUsers(userFollowPerspectiveAddress),
      builder:
          (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: Text('No subscriptions!',
                    style: Theme.of(context).textTheme.headline),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final UserProfile data = snapshot.data[index];
              return MemberPreview(profile: data);
            },
          );
        } else if (snapshot.hasError) {
          Container(
            child: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        return ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 120,
            child: Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: JuntoProgressIndicator(),
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _displayPending(BuildContext context, String userAddress) {
    return FutureBuilder<List<UserProfile>>(
      future: Provider.of<UserRepo>(context).pendingConnections(userAddress),
      builder:
          (BuildContext context, AsyncSnapshot<List<UserProfile>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: Text('No pending connection requests!',
                    style: Theme.of(context).textTheme.headline),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final UserProfile data = snapshot.data[index];
              return RelationshipRequest(data);
            },
          );
        } else if (snapshot.hasError) {
          Container(
            child: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        return ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 120,
            child: Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: JuntoProgressIndicator(),
              ),
            ),
          ),
        ]);
      },
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
