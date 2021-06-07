import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/widgets/appbar/global_invite_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/global_search_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/appbar_logo.dart';
import 'package:junto_beta_mobile/app/theme/themes_provider.dart';
import 'package:provider/provider.dart';

typedef SwitchColumnView = Future<void> Function(ExpressionFeedLayout layout);

// Junto app bar used in collective screen.
class DenAppbar extends SliverPersistentHeaderDelegate {
  DenAppbar({
    @required this.expandedHeight,
    @required this.heading,
  });

  final double expandedHeight;
  final String heading;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        height: MediaQuery.of(context).size.height * .1,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          left: 10,
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
            Container(
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  AppbarLogo(theme: theme),
                  const SizedBox(width: 7.5),
                  Text(
                    heading,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GlobalInviteIcon(),
                GlobalSearchIcon(),
                NotificationsLunarIcon(),
              ],
            )
          ],
        ),
      );
    });
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
