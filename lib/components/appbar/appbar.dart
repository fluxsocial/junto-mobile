import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class JuntoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JuntoAppBar({
    Key key,
    @required this.juntoAppBarTitle,
  }) : super(key: key);

  final String juntoAppBarTitle;

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: <double>[
                  0.1,
                  0.9
                ],
                colors: <Color>[
                  JuntoPalette.juntoSecondary,
                  JuntoPalette.juntoPrimary
                ]),
          ),
        ),
      ),
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/junto-mobile__logo.png',
                          height: 20.0, width: 20.0),
                      Container(
                        margin: const EdgeInsets.only(left: 7.5),
                        child: Text(juntoAppBarTitle,
                            style: JuntoStyles.appbarTitle),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => GlobalSearch(),
                      ),
                    );
                  },
                  child: Container(
                    child: Icon(Icons.search,
                        color: JuntoPalette.juntoSleek,
                        size: JuntoStyles.appbarIcon),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => JuntoNotifications(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 7.5),
                    child: Icon(CustomIcons.moon,
                        color: JuntoPalette.juntoSleek,
                        size: JuntoStyles.appbarIcon),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
