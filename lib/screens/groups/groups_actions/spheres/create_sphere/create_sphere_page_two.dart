import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';

class CreateSpherePageTwo extends StatelessWidget {
  const CreateSpherePageTwo({
    Key key,
    @required this.tabs,
    @required this.future,
    @required this.addMember,
    @required this.removeMember,
  }) : super(key: key);
  final List<String> tabs;
  final Future<Map<String, dynamic>> future;
  final ValueChanged<UserProfile> addMember;
  final ValueChanged<UserProfile> removeMember;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
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
                    for (String name in tabs)
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              // get list of connections
              final List<UserProfile> _connectionsMembers =
                  snapshot.data['connections']['results'];

              // get list of following
              final List<UserProfile> _followingMembers =
                  snapshot.data['following']['results'];

              return TabBarView(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      for (UserProfile member in _followingMembers)
                        MemberPreviewSelect(
                          profile: member,
                          onSelect: addMember,
                          onDeselect: removeMember,
                        ),
                    ],
                  ),
                  // connections
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      for (UserProfile connection in _connectionsMembers)
                        MemberPreviewSelect(
                          profile: connection,
                          onSelect: addMember,
                          onDeselect: removeMember,
                        ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
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
              ],
            );
          },
        ),
      ),
    );
  }
}
