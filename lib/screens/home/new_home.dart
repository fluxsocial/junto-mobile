import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/material_app_with_theme.dart';

import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/circles.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/bottom_bar/junto_bottom_bar.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';

class NewHome extends StatefulWidget {
  const NewHome({this.screen = Screen.groups});

  final Screen screen;
  @override
  State<StatefulWidget> createState() {
    return NewHomeState();
  }
}

class NewHomeState extends State<NewHome> with SingleTickerProviderStateMixin {
  UserData _userData;
  UserDataProvider userProvider;

  @override
  void initState() {
    super.initState();

    context.read<CircleBloc>().add(FetchMyCircle());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppRepo>(context, listen: false).initHome(widget.screen);
      fetchNotifications();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserDataProvider>(context, listen: false);
    getUserInformation();
  }

  void fetchNotifications() async {
    await Provider.of<NotificationsHandler>(context, listen: false)
        .fetchNotifications();
  }

  Future<void> getUserInformation() async {
    _userData = userProvider.userProfile;
  }

  Widget showScreen(Screen currentScreen, Group group) {
    Widget child;

    switch (currentScreen) {
      case Screen.collective:
        child = JuntoCollective();
        break;
      case Screen.groups:
        child = FeatureDiscovery(
          child: Circles(
            group: group,
          ),
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
        child = Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
        );
    }

    return child;
  }

  Widget showLeftDrawer(Screen currentScreen) {
    Widget child;

    switch (currentScreen) {
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state);
        if (state is AuthUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => HomePage(),
                transitionDuration: Duration(seconds: 0),
              ),
              (route) => false,
            );
          });
        }

        return Consumer<AppRepo>(builder: (context, snapshot, _) {
          return Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                if (snapshot.currentScreen == Screen.den) {
                  await Provider.of<AppRepo>(context, listen: false)
                      .changeScreen(screen: Screen.groups);
                  return false;
                }

                return true;
              },
              child: JuntoFilterDrawer(
                leftDrawer: null,
                rightMenu: JuntoDrawer(),
                swipeLeftDrawer: false,
                scaffold: Stack(
                  children: [
                    showScreen(snapshot.currentScreen, snapshot.group),
                    if (snapshot.showCreateScreen)
                      FadeIn(
                        duration: Duration(milliseconds: 300),
                        child: FeatureDiscovery(
                          child: CreateExpressionScaffold(
                            expressionContext: snapshot.expressionContext,
                            group: snapshot.group,
                          ),
                        ),
                      ),
                    if (snapshot.currentScreen != Screen.create)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: JuntoBottomBar(
                          userData: _userData,
                          currentScreen: snapshot.currentScreen,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
