import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:junto_beta_mobile/app/page_index_provider.dart';
import 'package:provider/provider.dart';

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
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _collectiveController = ScrollController();
    initializeBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final collectivePageIndex =
        Provider.of<PageIndexProvider>(context, listen: false)
            .collectivePageIndex;
    _currentIndex = collectivePageIndex;
    _pageController = PageController(initialPage: collectivePageIndex);
  }

  void initializeBloc() {
    context.bloc<PerspectivesBloc>().add(FetchPerspectives());
  }

  @override
  void dispose() {
    _collectiveController.dispose();
    _pageController.dispose();
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

  _collectiveViewNav() {
    print('yooo');
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
          leftDrawer: _currentIndex == 1
              ? FilterDrawerContent(ExpressionContextType.Collective)
              : null,
          rightMenu: JuntoDrawer(),
          swipeLeftDrawer: false,
          customSwipeRight: _currentIndex == 1 ? _collectiveViewNav : null,
          scaffold: NotificationListener<ScrollUpdateNotification>(
            onNotification: (value) => hideOrShowFab(value, _isFabVisible),
            child: Scaffold(
              key: _juntoCollectiveKey,
              body: Stack(
                children: <Widget>[
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      Provider.of<PageIndexProvider>(context, listen: false)
                          .setCollectivePageIndex(index);
                    },
                    controller: _pageController,
                    children: <Widget>[
                      JuntoPerspectives(
                        collectiveViewNav: _collectiveViewNav,
                      ),
                      Scaffold(
                        floatingActionButton: CollectiveActionButton(
                          isVisible: _isFabVisible,
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        body: ExpressionFeed(
                          collectiveViewNav: _collectiveViewNav,
                        ),
                      ),
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
