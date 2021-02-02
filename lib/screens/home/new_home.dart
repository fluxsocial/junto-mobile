import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
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
  UserData _userData;
  UserDataProvider userProvider;

  Screen _currentScreen;
  Screen _latestScreen;
  bool showCreateScreen = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      showCreateScreen = widget.screen == Screen.create;
    });
    _currentScreen = widget.screen;
    _latestScreen = widget.screen;
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
    _userData = userProvider.userProfile;
  }

  void changeScreen(Screen screen) {
    setState(() {
      _currentScreen = screen;
      if (screen == Screen.create) {
        showCreateScreen = true;
      } else {
        showCreateScreen = false;
        _latestScreen = screen;
      }
    });
  }

  void closeCreate() {
    setState(() {
      _currentScreen = _latestScreen;
      showCreateScreen = false;
      if (_latestScreen == Screen.create) {
        _currentScreen = Screen.collective;
      }
    });
    print(_currentScreen);
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

      case Screen.den:
        child = JuntoDen();
        break;
      default:
        child = JuntoCollective();
    }

    return child;
  }

  Widget showLeftDrawer() {
    Widget child;

    switch (_currentScreen) {
      case Screen.collective:
      case Screen.den:
        child = FilterDrawerContent(ExpressionContextType.Collective);
        break;
      case Screen.groups:
      case Screen.packs:
        child = FilterDrawerContent(ExpressionContextType.Group);
        break;
      default:
        child = FilterDrawerContent(ExpressionContextType.Collective);
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: showLeftDrawer(),
        rightMenu: JuntoDrawer(
          changeScreen: changeScreen,
        ),
        swipeLeftDrawer: false,
        scaffold: Stack(
          children: [
            if (!showCreateScreen) showScreen(),
            if (showCreateScreen)
              FeatureDiscovery(
                child: CreateExpressionScaffold(
                  closeCreate: closeCreate,
                  changeScreen: changeScreen,
                ),
              ),
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
      ),
    );
  }
}
