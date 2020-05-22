import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

import 'collective_actions/perspectives.dart';

// This class is a collective screen
class JuntoCollective extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoCollective();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective>
    with HideFab, SingleTickerProviderStateMixin {
  // Global key to uniquely identify Junto Collective
  final GlobalKey<ScaffoldState> _juntoCollectiveKey =
      GlobalKey<ScaffoldState>();

  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(true);
  ScrollController _collectiveController;

  @override
  void initState() {
    super.initState();

    _collectiveController = ScrollController();
    initializeBloc();
  }

  void initializeBloc() {
    context.bloc<PerspectivesBloc>().add(FetchPerspectives());
    context.bloc<CollectiveBloc>().add(
          FetchCollective(
            ExpressionQueryParams(
              contextType: ExpressionContextType.Collective,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _collectiveController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_collectiveController.hasClients) {
      _collectiveController.animateTo(
        0.0,
        duration: kTabScrollDuration,
        curve: Curves.decelerate,
      );
    }
  }

  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  _collectiveViewNav() {
    if (_currentIndex == 0) {
      _pageController.nextPage(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 300),
      );
    } else {
      _pageController.previousPage(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: JuntoFilterDrawer(
          leftDrawer: _currentIndex == 0
              ? FilterDrawerContent(ExpressionContextType.Collective)
              : null,
          rightMenu: JuntoDrawer(),
          scaffold: NotificationListener<ScrollUpdateNotification>(
            onNotification: (value) => hideOrShowFab(value, _isFabVisible),
            child: Scaffold(
              key: _juntoCollectiveKey,
              floatingActionButton: CollectiveActionButton(
                isVisible: _isFabVisible,
                onUpTap: _scrollToTop,
                actionsVisible: false,
                iconNorth: true,
                onTap: () {
                  context.bloc<PerspectivesBloc>().add(FetchPerspectives());
                  Navigator.push(
                    context,
                    FadeRoute(
                      child: JuntoPerspectives(),
                    ),
                  );
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              body: Stack(
                children: <Widget>[
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    controller: _pageController,
                    children: <Widget>[
                      ExpressionFeed(
                        collectiveViewNav: _collectiveViewNav,
                      ),
                      JuntoPerspectives(collectiveViewNav: _collectiveViewNav),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
