import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/appbar_logo.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class SpheresTempAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        height: MediaQuery.of(context).size.height * .1 + 50,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.bottomLeft,
                    color: Colors.transparent,
                    child: AppbarLogo(theme: theme),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        NotificationsLunarIcon(),
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
                            icon: OverlayInfoIcon(),
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
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      'GROUPS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
