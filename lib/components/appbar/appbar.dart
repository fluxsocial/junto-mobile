import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/typography/style.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate Widget.
class JuntoAppBar extends StatelessWidget {
  final juntoAppBarTitle;
  final navNotifications;

  JuntoAppBar(this.juntoAppBarTitle, this.navNotifications);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: .75,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.9],
                colors: [JuntoPalette.juntoBlue, JuntoPalette.juntoPurple]),
          ),
        ),
      ),
      backgroundColor: JuntoPalette.juntoWhite,
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/junto-mobile__logo.png',
                          height: 20.0, width: 20.0),
                      Container(
                        margin: EdgeInsets.only(left: 7.5),
                        child: Text(
                          juntoAppBarTitle,
                          textAlign: TextAlign.center,
                          style: JuntoStyles.appbarTitle,
                        ),
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
                      MaterialPageRoute(
                        builder: (context) => GlobalSearch(),
                      ),
                    );
                  },
                  child: Container(
                    child: Icon(Icons.search,
                        color: JuntoPalette.juntoSleek, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: navNotifications,
                  child: Container(
                    margin: EdgeInsets.only(left: 7.5),
                    child: Icon(CustomIcons.moon,
                        color: JuntoPalette.juntoSleek, size: 20),
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
