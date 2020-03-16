import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/appbar/filter_drawer_button.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';

// Junto app bar used in collective screen.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar(
      {@required this.expandedHeight,
      this.appbarTitle,
      this.twoColumnView,
      this.switchColumnView});

  final double expandedHeight;
  final String appbarTitle;
  final bool twoColumnView;
  final Function switchColumnView;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 135,
      child: Column(
        children: <Widget>[
          Container(
            height: 85,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
                color: Theme.of(context).backgroundColor),
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
                        appbarTitle,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 42,
                        color: Colors.transparent,
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(CustomIcons.moon,
                            size: 22, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              ],
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
                        onTap: () {
                          switchColumnView('two');
                        },
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.centerRight,
                          width: 38,
                          child: Icon(CustomIcons.twocolumn,
                              size: 20,
                              color: twoColumnView
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchColumnView('single');
                        },
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.centerRight,
                          width: 38,
                          child: Icon(CustomIcons.singlecolumn,
                              size: 20,
                              color: twoColumnView
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark),
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
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
