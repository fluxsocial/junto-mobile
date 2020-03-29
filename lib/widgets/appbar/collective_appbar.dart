import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
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
                              width: 42,
                              color: Colors.transparent,
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                CustomIcons.moon,
                                size: 22,
                                color: Theme.of(context).primaryColor,
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
                      const FilterDrawerButton(),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => data
                                ?.switchColumnLayout(ExpressionFeedLayout.two),
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
