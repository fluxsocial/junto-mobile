import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/relationship_request.dart';
import 'package:junto_beta_mobile/models/models.dart';

class JuntoRelationships extends StatelessWidget {
  final List<String> _tabs = <String>[
    'Connections',
    'Subscriptions',
    'Subscribers',
    'Pending'
  ];

  List<UserProfile> mockProfiles = [
    UserProfile(
      address: '123e4567-e89b-23s3-a256-426655440000',
      bio: 'Hi there, this is a mock user profile',
      name: 'Testy',
      profilePicture: ['assets/images/junto-mobile__mockprofpic--one.png'],
      username: 'mcTesty',
      verified: false,
      website: <String>['https://www.twitter.com/Nash0x7E2'],
      location: <String>['Somewhere on Earth'],
      gender: <String>['Male'],
    ),
    UserProfile(
      address: '123e4567-e89b-23s3-a256-426655440000',
      bio: 'Hi there, this is a mock user profile',
      name: 'Testy',
      profilePicture: ['assets/images/junto-mobile__mockprofpic--one.png'],
      username: 'mcTesty',
      verified: false,
      website: <String>['https://www.twitter.com/Nash0x7E2'],
      location: <String>['Somewhere on Earth'],
      gender: <String>['Male'],
    ),
    UserProfile(
      address: '123e4567-e89b-23s3-a256-426655440000',
      bio: 'Hi there, this is a mock user profile',
      name: 'Testy',
      profilePicture: ['assets/images/junto-mobile__mockprofpic--one.png'],
      username: 'mcTesty',
      verified: false,
      website: <String>['https://www.twitter.com/Nash0x7E2'],
      location: <String>['Somewhere on Earth'],
      gender: <String>['Male'],
    ),
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
              Container(color: Colors.green, height: 200),
              Container(color: Colors.blue, height: 200),
              Container(color: Colors.orange, height: 200),
              ListView(
                children: <Widget>[
                  RelationshipRequest(mockProfiles[0]),
                  RelationshipRequest(mockProfiles[1]),
                  RelationshipRequest(mockProfiles[2]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayConnections() {}

  _displaySubscriptions() {}

  _displaySubscribers() {}

  _displayPending() {}
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
