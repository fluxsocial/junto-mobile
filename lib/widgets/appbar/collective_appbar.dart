import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:provider/provider.dart';
import 'global_search_icon.dart';
import 'lists_drawer.dart';
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
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                          padding: const EdgeInsets.only(left: 45, bottom: 5),
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
                                      isScrollControlled: true,
                                      builder: (BuildContext context) =>
                                          ListsDrawer(),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'c/junto',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          context
                                              .bloc<CollectiveBloc>()
                                              .currentPerspective
                                              .name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GlobalSearchIcon(),
                            NotificationsLunarIcon(),
                          ],
                        ),
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
                    FilterDrawerButton(
                      collectiveScreen: true,
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
                              color:
                                  Provider.of<AppRepo>(context, listen: false)
                                              .twoColumnLayout ==
                                          true
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
                              color:
                                  Provider.of<AppRepo>(context, listen: false)
                                              .twoColumnLayout ==
                                          true
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
        title:
            'This is the Collective community, the public space for everyone in Junto.',
        learnMore: true,
        hasUpNext: false,
        upNextText: [
          "Transparent, human-centered algorithms that filter content to create feeds according to high activity (not based on your previous activity)",
        ],
        learnMoreText: [
          "The Collective is a shared space that anyone on Junto can post into.",
          'Each community on Junto displays previews of content, where you open an expression to view its full scope, rather than see the expression and its captions, comments, and activity all at once.',
          "You can filter the Collective communtiy by channel (topic) or by specific people. Create your own custom 'Lists' of people to organize your feeds."
        ],
        child: Container(
          height: 24,
          child: JuntoInfoIcon(),
        ),
      ),
    );
  }
}
