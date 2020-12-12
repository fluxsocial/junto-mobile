import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/bottom_bar/junto_bottom_bar.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres_temp.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';

class NewHome extends StatefulWidget {
  const NewHome({this.screen = Screen.collective});

  final Screen screen;
  @override
  State<StatefulWidget> createState() {
    return NewHomeState();
  }
}

class NewHomeState extends State<NewHome> {
  String _userAddress;
  UserData _userData;
  UserDataProvider userProvider;

  Screen _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = widget.screen;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserDataProvider>(context, listen: false);
    getUserInformation();
    fetchNotifications();
  }

  void fetchNotifications() async {
    await Provider.of<NotificationsHandler>(context, listen: false)
        .fetchNotifications();
  }

  Future<void> getUserInformation() async {
    _userAddress = userProvider.userAddress;
    _userData = userProvider.userProfile;
  }

  void changeScreen(Screen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  Widget showScreen() {
    Widget child;

    switch (_currentScreen) {
      case Screen.collective:
        child = JuntoCollective();
        break;
      case Screen.groups:
        child = FeatureDiscovery(
          child: SpheresTemp(),
        );
        break;
      case Screen.packs:
        child = JuntoPacks(
          initialGroup: _userData.pack.address,
        );
        break;
      case Screen.create:
        child = FeatureDiscovery(
          child: CreateExpressionScaffold(),
        );
        break;
      case Screen.den:
        child = JuntoDen();
        break;
      default:
        child = JuntoCollective();
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return JuntoFilterDrawer(
      leftDrawer: null,
      rightMenu: JuntoDrawer(
        changeScreen: changeScreen,
      ),
      scaffold: Stack(
        children: [
          showScreen(),
          if (_currentScreen != Screen.create)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: JuntoBottomBar(
                userData: _userData,
                changeScreen: changeScreen,
                currentScreen: _currentScreen,
              ),
            ),
        ],
      ),
    );
  }
}
