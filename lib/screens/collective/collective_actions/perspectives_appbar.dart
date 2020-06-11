import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/widgets/appbar/appbar_logo.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class PerspectivesAppBar extends StatefulWidget {
  PerspectivesAppBar({this.collectiveViewNav});

  final Function collectiveViewNav;

  @override
  _PerspectivesAppBarState createState() => _PerspectivesAppBarState();
}

class _PerspectivesAppBarState extends State<PerspectivesAppBar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<OnBoardingRepo>(context);
    if (repo.showPerspectiveTutorial) {
      showCollectiveTutorial();
      repo.setViewed(HiveKeys.kShowPerspectiveTutorial, false);
    }
  }

  void showCollectiveTutorial() {
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
                  AppbarLogo(theme: theme),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: NotificationsLunarIcon(),
                        ),
                        GestureDetector(
                          onTap: showCollectiveTutorial,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
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
                      alignment: Alignment.centerRight,
                      child: JuntoDescribedFeatureOverlay(
                        icon: Icon(
                          Icons.add,
                          size: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                        featureId: 'create_perspective_id',
                        title: 'Click this icon to create a new perspective.',
                        learnMore: false,
                        hasUpNext: false,
                        isLastFeature: true,
                        child: Icon(
                          Icons.add,
                          size: 22,
                          color: Theme.of(context).primaryColor,
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
