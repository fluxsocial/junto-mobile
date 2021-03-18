import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

import 'collective_actions/perspectives.dart';

// This class is a collective screen
class JuntoCollective extends StatefulWidget {
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
        Provider.of<AppRepo>(context, listen: false).collectivePageIndex;
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
        key: _juntoCollectiveKey,
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
            Provider.of<AppRepo>(context, listen: false)
                .setCollectivePageIndex(index);
          },
          controller: _pageController,
          children: <Widget>[
            JuntoPerspectives(
              collectiveViewNav: _collectiveViewNav,
            ),
            Scaffold(
              body: ExpressionFeed(
                collectiveViewNav: _collectiveViewNav,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
