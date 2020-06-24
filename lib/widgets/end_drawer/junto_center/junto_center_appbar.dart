import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_name.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';

// Junto app bar used in collective screen.
class JuntoCommunityCenterAppbar extends SliverPersistentHeaderDelegate {
  JuntoCommunityCenterAppbar({
    @required this.expandedHeight,
    @required this.tabs,
  });

  final double expandedHeight;
  final List<String> tabs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: MediaQuery.of(context).size.height * .11 + 50,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * .11,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      color: Colors.transparent,
                      height: 38,
                      width: 38,
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        CustomIcons.back,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 38),
                    child: Text(
                      'Community Center',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 28,
                        width: 38,
                        alignment: Alignment.center,
                        child: NotificationsLunarIcon(),
                      ),
                      GestureDetector(
                        onTap: () {
                          FeatureDiscovery.clearPreferences(context, <String>{
                            'community_center_info_id',
                          });
                          FeatureDiscovery.discoverFeatures(
                            context,
                            const <String>{
                              'community_center_info_id',
                            },
                          );
                        },
                        child: JuntoDescribedFeatureOverlay(
                          icon: OverlayInfoIcon(),
                          featureId: 'community_center_info_id',
                          title:
                              'This is the Community Center, a shared space for updates and your feedback on how to improve this experience.',
                          learnMore: false,
                          isLastFeature: true,
                          child: Container(
                            height: 24,
                            width: 38,
                            padding: const EdgeInsets.only(bottom: 4),
                            color: Colors.transparent,
                            child: JuntoInfoIcon(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: TabBar(
              labelPadding: const EdgeInsets.all(0),
              isScrollable: true,
              labelColor: Theme.of(context).primaryColorDark,
              unselectedLabelColor: Theme.of(context).primaryColorLight,
              labelStyle: Theme.of(context).textTheme.subtitle1,
              indicatorWeight: 0.0001,
              tabs: <Widget>[
                for (String name in tabs) PackName(name: name),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
