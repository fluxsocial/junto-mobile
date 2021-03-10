import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/appbar/notifications_lunar_icon.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/backend/repositories/onboarding_repo.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/home/new_home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';

class JuntoLotus extends StatefulWidget {
  @override
  _JuntoLotusState createState() => _JuntoLotusState();
}

class _JuntoLotusState extends State<JuntoLotus> {
  OnBoardingRepo repo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchNotifications();
    repo = Provider.of<OnBoardingRepo>(context);
    if (repo.showLotusTutorial) {
      showTutorial();
      repo.setViewed(HiveKeys.kShowLotusTutorial, false);
    }
  }

  void fetchNotifications() async {
    await Provider.of<NotificationsHandler>(context, listen: false)
        .fetchNotifications();
  }

  /// Pushes new page onto the stack
  /// Allows to go back from the new page
  /// This way Lotus is always in the root of the app
  void _navigateTo(Screen screen) async {
    Widget child;
    switch (screen) {
      case Screen.collective:
        child = NewHome(screen: Screen.collective);
        break;
      case Screen.groups:
        child = NewHome(screen: Screen.groups);
        break;
      case Screen.packs:
        child = NewHome(screen: Screen.packs);
        break;
      case Screen.create:
        child = NewHome(screen: Screen.create);
        break;
      default:
        child = NewHome(screen: Screen.collective);
        break;
    }

    Navigator.of(context).pushReplacement(
      FadeRoute<void>(
        child: child,
      ),
    );
  }

  void showTutorial() {
    FeatureDiscovery.clearPreferences(context, <String>{
      'lotus_info_id',
      'lotus_groups_id',
      'lotus_create_id',
    });
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        'lotus_info_id',
        'lotus_groups_id',
        'lotus_create_id',
      },
    );
  }

  void initializeBloc() {
    context.bloc<PerspectivesBloc>().add(FetchPerspectives());
  }

  @override
  void initState() {
    super.initState();
    initializeBloc();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Consumer<JuntoThemesProvider>(
        builder: (BuildContext context, JuntoThemesProvider theme, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundTheme(),
            SafeArea(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const SizedBox(),
                                Row(
                                  children: <Widget>[
                                    NotificationsLunarIcon(),
                                    GestureDetector(
                                      onTap: showTutorial,
                                      child: JuntoDescribedFeatureOverlay(
                                        icon: OverlayInfoIcon(),
                                        featureId: 'lotus_info_id',
                                        oneFeature: false,
                                        title:
                                            "Welcome to Junto! You can use this icon to access our tutorial throughout the app. Click 'Next' for a brief description of each section of the app.",
                                        learnMore: false,
                                        hasUpNext: false,
                                        child: JuntoInfoIcon(
                                          neutralBackground: false,
                                          theme: theme,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * .07,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'JUNTO',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        color: JuntoPalette()
                                            .juntoWhite(theme: theme)
                                            .withOpacity(.8),
                                        letterSpacing: 3.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          JuntoDescribedFeatureOverlay(
                            icon: Icon(
                              CustomIcons.newcollective,
                              size: 38,
                              color: Theme.of(context).primaryColor,
                            ),
                            featureId: 'lotus_groups_id',
                            title:
                                'Communities: Create and interact in public or private groups.',
                            learnMore: false,
                            hasUpNext: false,
                            isLastFeature: false,
                            contentLocation: ContentLocation.above,
                            child: LotusButton(
                              label: 'COMMUNITIES',
                              icon: CustomIcons.newcollective,
                              theme: theme,
                              iconSize: 38,
                              onTap: () => _navigateTo(Screen.groups),
                            ),
                          ),
                          SizedBox(height: 25),
                          JuntoDescribedFeatureOverlay(
                            icon: Icon(
                              CustomIcons.newcreate,
                              size: 38,
                              color: Theme.of(context).primaryColor,
                            ),
                            featureId: 'lotus_create_id',
                            title:
                                'Create: Share expressions in multiple social layers.',
                            learnMore: false,
                            hasUpNext: false,
                            contentLocation: ContentLocation.above,
                            isLastFeature: true,
                            child: (LotusButton(
                              label: s.lotus_create,
                              icon: CustomIcons.newcreate,
                              theme: theme,
                              iconSize: 38,
                              onTap: () => _navigateTo(Screen.create),
                            )),
                          ),
                          SizedBox(height: 25),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LotusButton extends StatelessWidget {
  const LotusButton({
    @required this.label,
    @required this.icon,
    @required this.onTap,
    @required this.theme,
    this.iconSize,
    Key key,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final JuntoThemesProvider theme;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Icon(
                      icon,
                      size: iconSize ?? 45,
                      color: JuntoPalette().juntoWhite(theme: theme),
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: JuntoPalette().juntoWhite(theme: theme),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
