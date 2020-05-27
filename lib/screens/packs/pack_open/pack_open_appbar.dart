import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_name.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_action_items.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:provider/provider.dart';

typedef SwitchColumnView = Future<void> Function(ExpressionFeedLayout layout);

// Junto app bar used in collective screen.
class PackOpenAppbar extends SliverPersistentHeaderDelegate {
  PackOpenAppbar({
    @required this.expandedHeight,
    @required this.pack,
    @required this.tabs,
    @required this.packsViewNav,
  });

  final double expandedHeight;
  final Group pack;
  final List<String> tabs;
  final Function packsViewNav;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<UserDataProvider>(
      builder: (context, user, child) {
        final userProfile = user.userProfile;
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
                        onTap: packsViewNav,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          color: Colors.transparent,
                          height: 38,
                          width: 38,
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.back,
                                size: 17,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 38),
                          child: GestureDetector(
                            onTap: () {
                              if (userProfile != null &&
                                  userProfile.pack.address != pack.address) {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  builder: (BuildContext context) =>
                                      PackOpenActionItems(
                                    pack: pack,
                                    userProfile: userProfile,
                                  ),
                                );
                              } else {
                                return;
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    pack.creator['username'].trim(),
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              FeatureDiscovery.clearPreferences(
                                  context, <String>{
                                'packs_info_id',
                              });
                              FeatureDiscovery.discoverFeatures(
                                context,
                                const <String>{
                                  'packs_info_id',
                                },
                              );
                            },
                            child: JuntoDescribedFeatureOverlay(
                              icon: OverlayInfoIcon(),
                              featureId: 'packs_info_id',
                              title:
                                  'This is a Pack. It is a group feed that displays the publicly shared posts of the people who have been invited in it. There is also a private section where the pack owner can share to just its pack members.',
                              learnMore: true,
                              learnMoreText: [
                                "Your Pack is meant for a group of close friends who evoke the most unfiltered version of you and reflect an extension of you. The people you invite to your Pack will have access to your Pack feed, which displays the public content of everyone you've invited. You are the common thread between all the people you invite, facilitating a more organic way for them to hear from or discover one another through their mutual connection - you. You can also share private expressions to just your pack members.",
                                'Also note that connecting by Packs is not mutual. If someone accepts your pack invitation, you will not be able to see their Pack feed unless they choose to send you an invite.'
                              ],
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
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
