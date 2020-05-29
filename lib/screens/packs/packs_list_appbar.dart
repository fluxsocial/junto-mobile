import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class PacksListAppBar extends StatefulWidget {
  PacksListAppBar({
    this.currentIndex,
    this.packsListNav,
  });

  final Function packsListNav;
  final int currentIndex;

  @override
  _PacksListAppBarState createState() => _PacksListAppBarState();
}

class _PacksListAppBarState extends State<PacksListAppBar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<OnBoardingRepo>(context);
    if (repo.showPackTutorial) {
      showTutorial();
      repo.setViewed(HiveKeys.kShowPackTutorial, false);
    }
  }

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

  void showTutorial() {
    FeatureDiscovery.clearPreferences(context, <String>{
      'packs_list_info_id',
    });
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'packs_list_info_id',
      },
    );
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
                    child: Image.asset(
                      logo(theme.themeName),
                      height: 24,
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        NotificationsLunarIcon(),
                        GestureDetector(
                          onTap: showTutorial,
                          child: JuntoDescribedFeatureOverlay(
                            icon: OverlayInfoIcon(),
                            featureId: 'packs_list_info_id',
                            title:
                                'This is the list of Packs you belong to. Each person can only create one pack, but can belong to many others.',
                            learnMore: true,
                            learnMoreText: [
                              "Your Pack is your group of close friends who evoke the most unfiltered version of you and reflect an extension of you. The people you invite to your Pack will have access to your Pack feed, which displays the public content of everyone in it. In this light, you are the common thread between all the people you invite, facilitating a more organic way for them to hear from or discover one another through their mutual connection - you. You can also share private expressions to just your pack members.",
                              'Also note that connecting by Packs is not mutual. If someone accepts your pack invitation, you will not be able to see their Pack feed unless they choose to send you an invitation.'
                            ],
                            isLastFeature: true,
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.bottomRight,
                              child: JuntoInfoIcon(),
                            ),
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
                  GestureDetector(
                    onTap: widget.packsListNav,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        'PACKS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: widget.currentIndex == 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: widget.currentIndex == 0
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.packsListNav,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      margin: const EdgeInsets.only(right: 20),
                      child: Text(
                        'REQUESTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: widget.currentIndex == 1
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: widget.currentIndex == 1
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                        ),
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
