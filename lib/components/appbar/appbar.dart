import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/typography/style.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate
// Widget.
class JuntoAppBar extends StatelessWidget {
  const JuntoAppBar({
    Key key,
    @required this.juntoAppBarTitle,
    @required this.navNotifications,
  }) : super(key: key);

  final String juntoAppBarTitle;
  final VoidCallback navNotifications;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
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
                  JuntoPalette.juntoPurple,
                  JuntoPalette.juntoBlue
                ]),
          ),
        ),
      ),
      backgroundColor: JuntoPalette.juntoWhite,
      brightness: Brightness.light,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => GlobalSearch(),
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
                    margin: const EdgeInsets.only(left: 7.5),
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
