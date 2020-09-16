import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_appbar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_fab.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_feedback.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_updates.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/app/community_center_addresses.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';

class JuntoCommunityCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoCommunityCenterState();
  }
}

class JuntoCommunityCenterState extends State<JuntoCommunityCenter> {
  final List<String> _tabs = ['UPDATES', 'FEEDBACK'];
  Map<String, dynamic> relationToFeedback;
  Map<String, dynamic> relationToUpdates;

  @override
  void initState() {
    super.initState();
    getRelationToGroup();
  }

  Future<void> getRelationToGroup() async {
    final UserProfile userProfile =
        await Provider.of<UserDataProvider>(context, listen: false)
            .userProfile
            .user;
    // get relation to feedback group
    final Map<String, dynamic> feedbackRelation =
        await Provider.of<GroupRepo>(context, listen: false)
            .getRelationToGroup(kCommunityCenterAddress, userProfile.address);

    // If the member is not apart of the feedback group, add them
    if (feedbackRelation['member'] == false &&
        feedbackRelation['creator'] == false) {
      joinFeedbackGroup(userProfile);
    }

    // get relation to updates group
    final Map<String, dynamic> updatesRelation =
        await Provider.of<GroupRepo>(context, listen: false)
            .getRelationToGroup(kCommunityCenterAddress, userProfile.address);

    // If the member is not apart of the updates group, add them
    if (updatesRelation['member'] == false &&
        updatesRelation['creator'] == false) {
      joinUpdatesGroup(userProfile);
    }

    // set state
    setState(() {
      relationToFeedback = feedbackRelation;
      relationToUpdates = updatesRelation;
    });
  }

  // Join Community Center Feedback Group
  Future<void> joinFeedbackGroup(UserProfile userProfile) async {
    // Add member to community center on sign up
    await Provider.of<GroupRepo>(context, listen: false)
        .addGroupMember(kCommunityCenterAddress, [userProfile], 'Member');
  }

  // Join Community Center Updates Group
  Future<void> joinUpdatesGroup(UserProfile userProfile) async {
    // Add member to updates on sign up
    await Provider.of<GroupRepo>(context, listen: false)
        .addGroupMember(kUpdatesAddress, [userProfile], 'Member');
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        floatingActionButton: JuntoCommunityCenterFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            floatHeaderSlivers: true,
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
                JuntoCommunityCenterUpdates(),
                JuntoCommunityCenterFeedback(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
