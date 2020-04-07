import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres_temp.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:provider/provider.dart';

class JuntoLotus extends StatefulWidget {
  const JuntoLotus({
    Key key,
    @required this.expressionContext,
    @required this.address,
  })  : assert(expressionContext != null),
        assert(address != ''),
        super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() => JuntoLotusState();
}

class JuntoLotusState extends State<JuntoLotus> {
  static Route<dynamic> route() {
    return FadeRoute<void>(
      child: const JuntoLotus(
        address: null,
        expressionContext: ExpressionContext.Collective,
      ),
      name: 'JuntoLotus',
    );
  }

  bool backButtonTappedOnce = false;
  ThemeData _currentTheme;

  /// Pushes new page onto the stack
  /// Allows to go back from the new page
  /// This way Lotus is always in the root of the app
  void _navigateTo(Screen screen) {
    final _userProfile =
        Provider.of<UserDataProvider>(context, listen: false).userProfile;
    Widget child;
    if (screen == Screen.collective) {
      child = JuntoCollective();
    } else if (screen == Screen.packs) {
      child = JuntoPacks(initialGroup: _userProfile.pack.address);
    } else if (screen == Screen.groups) {
      child = FeatureDiscovery(
        child: SpheresTemp(),
      );
    } else if (screen == Screen.create) {
      child = FeatureDiscovery(
        child: JuntoCreate(
          channels: const <String>[],
          address: widget.address,
          expressionContext: widget.expressionContext,
          currentTheme: _currentTheme,
        ),
      );
    }
    backButtonTappedOnce = false;
    Navigator.of(context).push(
      FadeRoute<void>(child: child, name: child.runtimeType.toString()),
    );
    return;
  }

  Future<void> getTheme() async {
    final theme = await Provider.of<JuntoThemesProvider>(context, listen: false)
        .getTheme();
    setState(() {
      _currentTheme = theme;
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GestureDetector(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundTheme(currentTheme: _currentTheme),
            SafeArea(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                FeatureDiscovery.clearPreferences(
                                    context, <String>{
                                  'lotus_info_id',
                                });
                                FeatureDiscovery.discoverFeatures(
                                  context,
                                  const <String>{
                                    'lotus_info_id',
                                  },
                                );
                              },
                              child: JuntoDescribedFeatureOverlay(
                                icon: Icon(
                                  CustomIcons.newflower,
                                  size: 38,
                                  color: Theme.of(context).primaryColor,
                                ),
                                featureId: 'lotus_info_id',
                                oneFeature: true,
                                title:
                                    'This is the intention screen, your medium for navigation.',
                                learnMore: true,
                                learnMoreText: [
                                  'The purpose of the intention screen is to reduce noise and to invite a more mindful, self-directed experience. Instead of immediately being dropped into a feed when you open the app, this screen makes your initial experience a choice and encourages more reflection while navigating between screens.'
                                ],
                                hasUpNext: false,
                                child: JuntoInfoIcon(neutralBackground: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          LotusButton(
                            label: s.lotus_collective,
                            icon: CustomIcons.newcollective,
                            onTap: () => _navigateTo(Screen.collective),
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: LotusButton(
                                    label: s.lotus_packs,
                                    icon: CustomIcons.newpacks,
                                    iconSize: 38,
                                    onTap: () => _navigateTo(Screen.packs),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: LotusButton(
                                    label: s.lotus_groups,
                                    icon: CustomIcons.newcircles,
                                    iconSize: 38,
                                    onTap: () => _navigateTo(Screen.groups),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LotusButton(
                            label: s.lotus_create,
                            icon: CustomIcons.newcreate,
                            iconSize: 38,
                            onTap: () => _navigateTo(Screen.create),
                          ),
                          const SizedBox(height: 25),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LotusButton extends StatelessWidget {
  const LotusButton({
    @required this.label,
    @required this.icon,
    @required this.onTap,
    this.iconSize,
    Key key,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
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
