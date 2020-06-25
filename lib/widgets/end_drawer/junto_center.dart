import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_appbar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_fab.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_feedback.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoCommunityCenter extends StatelessWidget {
  final List<String> _tabs = ['FEEDBACK'];
  final String communityCenterAddress = '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        floatingActionButton: SafeArea(
          child: JuntoCommunityCenterFab(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                  delegate: JuntoCommunityCenterAppbar(
                    expandedHeight:
                        MediaQuery.of(context).size.height * .11 + 50,
                    tabs: _tabs,
                  ),
                  floating: true,
                  pinned: false,
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                JuntoCommunityCenterFeedback(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
