import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/about_perspective.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:provider/provider.dart';
import 'notifications_lunar_icon.dart';

typedef SwitchColumnView = Future<void> Function(ExpressionFeedLayout layout);

// Junto app bar used in collective screen.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar({
    @required this.expandedHeight,
    @required this.appbarTitle,
    @required this.collectiveViewNav,
  });

  final double expandedHeight;
  final String appbarTitle;
  final Function collectiveViewNav;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, UserDataProvider data, Widget child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 10),
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
                        onTap: collectiveViewNav,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 10),
                          color: Colors.transparent,
                          height: 38,
                          width: 38,
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
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(left: 38),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      builder: (BuildContext context) =>
                                          AboutPerspective(),
                                    );
                                  },
                                  child: Text(
                                    appbarTitle ?? 'JUNTO',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.bottomRight,
                            width: 38,
                            child: NotificationsLunarIcon(),
                          ),
                          Container(
                            color: Colors.transparent,
                            width: 38,
                            child: AppBarFeatureDiscovery(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    JuntoDescribedFeatureOverlay(
                      icon: Image.asset(
                        'assets/images/junto-mobile__filter.png',
                        height: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      featureId: 'collective_filter_id',
                      title:
                          'Click this icon to filter this perspective by channel.',
                      isLastFeature: true,
                      child: const FilterDrawerButton(),
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => data
                              ?.switchColumnLayout(ExpressionFeedLayout.two),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              CustomIcons.twocolumn,
                              size: 20,
                              color: data?.twoColumnView == true
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => data
                              ?.switchColumnLayout(ExpressionFeedLayout.single),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              CustomIcons.singlecolumn,
                              size: 20,
                              color: data?.twoColumnView == true
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class AppBarFeatureDiscovery extends StatefulWidget {
  const AppBarFeatureDiscovery({
    Key key,
  }) : super(key: key);

  @override
  _AppBarFeatureDiscoveryState createState() => _AppBarFeatureDiscoveryState();
}

class _AppBarFeatureDiscoveryState extends State<AppBarFeatureDiscovery> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<OnBoardingRepo>(context);
    if (repo.showCollectiveTutorial) {
      repo.setViewed(HiveKeys.kShowCollectiveTutorial, false);
      showTutorial();
    }
  }

  void showTutorial() {
    FeatureDiscovery.clearPreferences(context, <String>{
      'collective_info_id',
      'collective_filter_id',
    });
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'collective_info_id',
        'collective_filter_id',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showTutorial,
      child: JuntoDescribedFeatureOverlay(
        icon: OverlayInfoIcon(),
        featureId: 'collective_info_id',
        title: 'This is the Collective, where all public content is shown.',
        learnMore: true,
        hasUpNext: true,
        upNextText: [
          "Transparent, human-centered algorithms that filter content to create feeds according to high activity (not based on your previous activity)",
        ],
        learnMoreText: [
          "The Collective is a shared space that anyone on Junto can post into. Our hope is that people will discover meaningful content and relationships with those they may not know and help to maintain a positive culture.",
          'You can view content in this layer through "Perspectives". Perspectives are feeds that show filtered content from the Collective. They display previews of content, where you open an expression to view its full scope, rather than see the expression and its captions, comments, and activity all at once.'
        ],
        child: Container(
          height: 24,
          child: JuntoInfoIcon(),
        ),
      ),
    );
  }
}
