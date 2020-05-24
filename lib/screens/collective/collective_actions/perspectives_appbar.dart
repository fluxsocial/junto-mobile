import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class PerspectivesAppBar extends StatelessWidget {
  PerspectivesAppBar({this.collectiveViewNav});

  final Function collectiveViewNav;

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
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        height: MediaQuery.of(context).size.height * .1 + 50,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
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
                  GestureDetector(
                    onTap: collectiveViewNav,
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.bottomLeft,
                      color: Colors.transparent,
                      child: Image.asset(
                        logo(theme.themeName),
                        height: 24,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (ctx) => CreatePerspectivePage(),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Transform.translate(
                              offset: Offset(0.0, 4),
                              child: JuntoDescribedFeatureOverlay(
                                icon: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Theme.of(context).primaryColor,
                                ),
                                featureId: 'create_perspective_id',
                                title:
                                    'Click this icon to create a new perspective.',
                                learnMore: false,
                                hasUpNext: false,
                                isLastFeature: true,
                                child: Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: NotificationsLunarIcon(),
                        ),
                        GestureDetector(
                          onTap: () {
                            FeatureDiscovery.clearPreferences(context, <String>{
                              'perspectives_info_id',
                              'create_perspective_id',
                            });
                            FeatureDiscovery.discoverFeatures(
                              context,
                              const <String>{
                                'perspectives_info_id',
                                'create_perspective_id',
                              },
                            );
                          },
                          child: JuntoDescribedFeatureOverlay(
                            icon: OverlayInfoIcon(),
                            featureId: 'perspectives_info_id',
                            title:
                                'This is your list of your perspectives. There are three by default - you can also make your own.',
                            learnMore: true,
                            hasUpNext: true,
                            learnMoreText: [
                              'Creating your own Perspective means creating your own feed with content from specific people. Our design inspiration here is to give you more agency over what you see, rather than building your feed with complex, opaque algorithms that form echo chambers and track your previous activity. Create your own perspective to organize what you care about.'
                            ],
                            upNextText: [
                              'Create perspectives that show expressions from specific people within certain channels',
                              'Share perspectives with others',
                              'Create sub perspectives'
                            ],
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
                    margin: const EdgeInsets.only(right: 20),
                    color: Theme.of(context).colorScheme.background,
                    child: Text(
                      'PERSPECTIVES',
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
