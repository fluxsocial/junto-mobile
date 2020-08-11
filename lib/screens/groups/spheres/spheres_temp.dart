import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'spheres_temp_appbar.dart';

// This screen displays the temporary page we'll display until groups are released
class SpheresTemp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * .1 + 50,
            ),
            child: SpheresTempAppBar(),
          ),
          floatingActionButton: BottomNav(
            address: null,
            expressionContext: ExpressionContext.Group,
            source: Screen.groups,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Transform.translate(
                offset: Offset(0.0, -60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/junto-mobile__groups--placeholder.png',
                      height: 170,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'We will open this layer soon.',
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
