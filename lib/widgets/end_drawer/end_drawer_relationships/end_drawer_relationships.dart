import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/notification_signal.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pending/pending_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/subscriptions.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/subscribers.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/connections.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/pack_members.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
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
  List<UserProfile> pendingConnectionRequests;
  List<UserProfile> pendingPackRequests;

  final List<String> _tabs = <String>[
    'SUBSCRIPTIONS',
    'SUBSCRIBERS',
    'CONNECTIONS',
    'MY PACK',
  ];

  Future<void> getUserRelationships() async {
    final dynamic userRelations =
        await Provider.of<UserRepo>(context, listen: false).userRelations();
    setState(() {
      pendingConnectionRequests =
          userRelations['pending_connections']['results'];
      pendingPackRequests =
          userRelations['pending_group_join_requests']['results'];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserRelationships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          elevation: 0,
          titleSpacing: 0,
          brightness: Theme.of(context).brightness,
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
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                PendingRelationships(
                              userAddress: widget.userAddress,
                              refreshActions: getUserRelationships,
                            ),
                          ),
                        );
                      },
                      child: JuntoDescribedFeatureOverlay(
                        icon: Icon(
                          CustomIcons.request,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        featureId: 'pending_requests_id',
                        isLastFeature: true,
                        title: 'View your pending requests.',
                        learnMore: false,
                        hasUpNext: false,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Icon(
                                CustomIcons.request,
                                color: Theme.of(context).primaryColorDark,
                                size: 17,
                              ),
                            ),
                            if (pendingConnectionRequests != null &&
                                pendingPackRequests != null)
                              if (pendingConnectionRequests.isNotEmpty ||
                                  pendingPackRequests.isNotEmpty)
                                NotificationSignal(
                                  top: 10,
                                  right: 5,
                                ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FeatureDiscovery.clearPreferences(context, <String>{
                          'relations_info_id',
                          'pending_requests_id',
                        });
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String>{
                            'relations_info_id',
                            'pending_requests_id',
                          },
                        );
                      },
                      child: JuntoDescribedFeatureOverlay(
                        icon: OverlayInfoIcon(),
                        featureId: 'relations_info_id',
                        title:
                            'This screen shows the different relations you have with people on Junto.',
                        learnMore: true,
                        hasUpNext: false,
                        learnMoreText: [
                          'On Junto, there are multiple relational layers to reflect the more dynamic nature of our physical world relationships.',
                          '"Subscriptions" are people you have added to your Subscriptions perspective (not mutual)',
                          '"Subscribers" are people who have added you to their Subscriptions perspective (not mutual)',
                          '"Connections" are your first degree friendships. Choosing to connect with someone is like friending them (mutual).',
                          'Your "Pack" is your closest group of friends (not mutual). Visit the tutorial in your Pack feed for more information.'
                        ],
                        child: JuntoInfoIcon(),
                      ),
                    ),
                  ],
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
          body: TabBarView(
            children: <Widget>[
              // subscriptions
              Subscriptions(),

              // subscribers
              Subscribers(),

              // connections
              Connections(),

              // pack members
              PackMembers(userAddress: widget.userAddress),
            ],
          ),
        ),
      ),
    );
  }
}
