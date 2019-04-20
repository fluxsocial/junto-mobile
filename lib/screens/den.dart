
import 'package:flutter/material.dart';

// typography + icons
import './../palette.dart';

// appbar + bottom nav
import '../components/appbar/appbar.dart';
import '../components/appbar_border/appbar_border.dart';
import './../components/bottom_nav/bottom_nav.dart';

class JuntoDen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: juntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--den.png', 'DEN'),

        body: Column(
          children: <Widget>[
            // App bar border
            AppbarBorder(JuntoPalette.juntoGrey)
          ],
        ),
        bottomNavigationBar: BottomNav());
  }
}
