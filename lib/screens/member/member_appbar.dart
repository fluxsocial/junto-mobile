import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';

typedef SwitchColumnView = Future<void> Function(ExpressionFeedLayout layout);

// Junto app bar used in collective screen.
class MemberAppbar extends SliverPersistentHeaderDelegate {
  MemberAppbar({
    @required this.expandedHeight,
    @required this.username,
  });

  final double expandedHeight;
  final String username;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: MediaQuery.of(context).viewPadding.top + 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          left: 0, bottom: 0, top: MediaQuery.of(context).viewPadding.top),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Icon(
                CustomIcons.back,
                color: Theme.of(context).primaryColorDark,
                size: 17,
              ),
            ),
          ),
          Text(
            username.toLowerCase(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(width: 42),
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
