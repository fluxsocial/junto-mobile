import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
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

  String logo(String theme) {
    if (theme == 'rainbow' || theme == 'rainbow-night') {
      return 'assets/images/junto-mobile__logo--rainbow.png';
    } else if (theme == 'aqueous' || theme == 'aqueous-night') {
      return 'assets/images/junto-mobile__logo--aqueous.png';
    } else if (theme == 'royal' || theme == 'royal-night') {
      return 'assets/images/junto-mobile__logo--purpgold.png';
    } else {
      return 'assets/images/junto-mobile__logo--rainbow.png';
    }
  }

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
                  Image.asset(
                    logo(theme.themeName),
                    height: 24.0,
                    width: 24.0,
                  ),
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
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Icon(
                      CustomIcons.newmoon,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
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
