import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_appbar.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoCommunityCenter extends StatelessWidget {
  final List<String> _tabs = ['UPDATES', 'FEEDBACK'];

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
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
                SizedBox(),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
