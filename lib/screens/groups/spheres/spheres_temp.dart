import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/app/screens.dart';

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
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              brightness: Theme.of(context).brightness,
              automaticallyImplyLeading: false,
              elevation: 0,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              title: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Groups',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    GestureDetector(
                      onTap: () {
                        FeatureDiscovery.clearPreferences(context, <String>{
                          'groups_info_id',
                        });
                        FeatureDiscovery.discoverFeatures(
                          context,
                          const <String>{
                            'groups_info_id',
                          },
                        );
                      },
                      child: JuntoDescribedFeatureOverlay(
                        icon: Icon(
                          CustomIcons.newcircles,
                          size: 36,
                          color: Theme.of(context).primaryColor,
                        ),
                        featureId: 'groups_info_id',
                        isLastFeature: true,
                        title:
                            'Groups are public, private, or secret communities you can create on Junto. We will open this layer soon.',
                        learnMore: false,
                        child: JuntoInfoIcon(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: BottomNav(
              address: null,
              expressionContext: ExpressionContext.Group,
              actionsVisible: false,
              source: Screen.groups,
              onLeftButtonTap: () {},
            ),
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
