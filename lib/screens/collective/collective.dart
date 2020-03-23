import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
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
  final GlobalKey<JuntoFilterDrawerState> _filterDrawerKey =
      GlobalKey<JuntoFilterDrawerState>();

  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(true);
  ScrollController _collectiveController;

  @override
  void initState() {
    super.initState();

    _collectiveController = ScrollController();
    context.bloc<PerspectivesBloc>().add(FetchPerspectives());
    context.bloc<CollectiveBloc>().add(
          FetchCollective(
            ExpressionQueryParams(
              contextType: ExpressionContextType.Collective,
            ),
          ),
        );
    _addPostFrameCallbackToHideFabOnScroll();
  }

  @override
  void dispose() {
    _collectiveController.removeListener(_onScrollingHasChanged);
    _collectiveController.dispose();
    super.dispose();
  }

  void _addPostFrameCallbackToHideFabOnScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _collectiveController.addListener(_onScrollingHasChanged);
      if (_collectiveController.hasClients) {
        _collectiveController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
      }
    });
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

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, _isFabVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: JuntoFilterDrawer(
        key: _filterDrawerKey,
        leftDrawer: const FilterDrawerContent(ExpressionContextType.Collective),
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          key: _juntoCollectiveKey,
          floatingActionButton: CollectiveActionButton(
            isVisible: _isFabVisible,
            onUpTap: _scrollToTop,
            actionsVisible: false,
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
          body: ExpressionFeed(collectiveController: _collectiveController),
        ),
      ),
    );
  }
}
