import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:provider/provider.dart';

typedef SwitchColumnView = Future<void> Function(ExpressionFeedLayout layout);

// Junto app bar used in collective screen.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar({
    @required this.expandedHeight,
    @required this.appbarTitle,
  });

  final double expandedHeight;
  final String appbarTitle;

  final action = () async {
    print('IconButton of  tapped.');
    return true;
  };

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, UserDataProvider data, Widget child) {
        return Container(
          height: MediaQuery.of(context).size.height * .1 + 50,
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
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
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 10),
                        color: Colors.transparent,
                        height: 36,
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__logo.png',
                              height: 22.0,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 7.5),
                            Text(
                              appbarTitle ?? 'JUNTO',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => NotificationsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.bottomCenter,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Icon(
                                CustomIcons.moon,
                                size: 22,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          RaisedButton(onPressed: () {
                            FeatureDiscovery.clearPreferences(context, <String>{
                              'information_id',
                              'arrow_id',
                              'filter_id',
                              'twocolumn_id',
                            });
                            FeatureDiscovery.discoverFeatures(
                              context,
                              const <String>{
                                'information_id',
                                'arrow_id',
                                'filter_id',
                                'twocolumn_id',
                              },
                            );
                          }),
                          JuntoDescribedFeatureOverlay(
                            icon: Icon(
                              CustomIcons.newcollective,
                              size: 36,
                              color: Colors.white,
                            ),
                            featureId: 'information_id',
                            title: 'This is the Collective of Junto',
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: JuntoInfoIcon(),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).dividerColor, width: .75),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DescribedFeatureOverlay(
                        tapTarget: Icon(Icons.add),
                        featureId: 'filter_id',
                        backgroundColor: Theme.of(context).accentColor,
                        contentLocation: ContentLocation.below,
                        title: const Text('Find the fastest route'),
                        targetColor: Theme.of(context).backgroundColor,
                        onComplete: action,
                        enablePulsingAnimation: false,
                        description: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                                'Tap the magnifying glass to quickly scan your compounds'),
                            FlatButton(
                              padding: const EdgeInsets.all(0),
                              child: Text('Understood',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white)),
                              onPressed: () async =>
                                  FeatureDiscovery.completeCurrentStep(context),
                            ),
                            FlatButton(
                              padding: const EdgeInsets.all(0),
                              child: Text('Dismiss',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white)),
                              onPressed: () =>
                                  FeatureDiscovery.dismissAll(context),
                            ),
                          ],
                        ),
                        onOpen: () async {
                          print('The overlay is about to be displayed.');
                          return true;
                        },
                        child: const FilterDrawerButton(),
                      ),
                      Row(
                        children: <Widget>[
                          DescribedFeatureOverlay(
                            tapTarget: Icon(Icons.add),
                            featureId: 'twocolumn_id',
                            backgroundColor: Theme.of(context).primaryColor,
                            contentLocation: ContentLocation.below,
                            title: const Text('Find the fastest route'),
                            onComplete: action,
                            enablePulsingAnimation: false,
                            description: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                    'Tap the magnifying glass to quickly scan your compounds'),
                                FlatButton(
                                  padding: const EdgeInsets.all(0),
                                  child: Text('Understood',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(color: Colors.white)),
                                  onPressed: () async =>
                                      FeatureDiscovery.completeCurrentStep(
                                          context),
                                ),
                                FlatButton(
                                  padding: const EdgeInsets.all(0),
                                  child: Text('Dismiss',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(color: Colors.white)),
                                  onPressed: () =>
                                      FeatureDiscovery.dismissAll(context),
                                ),
                              ],
                            ),
                            onOpen: () async {
                              print('The overlay is about to be displayed.');
                              return true;
                            },
                            child: GestureDetector(
                              onTap: () => data?.switchColumnLayout(
                                  ExpressionFeedLayout.two),
                              child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.centerRight,
                                width: 38,
                                child: Icon(
                                  CustomIcons.twocolumn,
                                  size: 20,
                                  color: data?.twoColumnView == true
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => data?.switchColumnLayout(
                                ExpressionFeedLayout.single),
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              width: 38,
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
