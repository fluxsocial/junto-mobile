import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_appbar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_fab.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_feedback.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_updates.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';

class JuntoCommunityCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoCommunityCenterState();
  }
}

class JuntoCommunityCenterState extends State<JuntoCommunityCenter>
    with TickerProviderStateMixin {
  final List<String> _tabs = ['FEEDBACK', 'UPDATES'];
  final String communityCenterAddress = '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

  Map<String, dynamic> relationToGroup;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _tabs.length, vsync: this);
    getRelationToGroup();
  }

  Future<void> getRelationToGroup() async {
    // get user address
    final String userAddress =
        await Provider.of<UserDataProvider>(context, listen: false).userAddress;
    // get relation to updates group
    final Map<String, dynamic> relation =
        await Provider.of<GroupRepo>(context, listen: false).getRelationToGroup(
            '2eb976b4-4473-2436-ccb2-e512e868bcac', userAddress);
    // set state
    setState(() {
      relationToGroup = relation;
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

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
                    tabController: tabController,
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
              controller: tabController,
              children: <Widget>[
                JuntoCommunityCenterFeedback(),
                JuntoCommunityCenterUpdates(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
