import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar_name.dart';

import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoDenState();
  }
}

class JuntoDenState extends State<JuntoDen>
    with HideFab, TickerProviderStateMixin {
  bool showComments = false;
  ScrollController _denController;
  TabController _tabController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  final List<String> _tabs = [
    'Collective',
    'Feedback',
    'Replies',
  ];
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    _denController = ScrollController();
    _tabController = TabController(
      vsync: this,
      initialIndex: 0,
      length: _tabs.length,
    );
    _tabController.addListener(_setCurrentIndex);
  }

  @override
  void dispose() {
    _denController.dispose();
    _tabController.removeListener(_setCurrentIndex);
    _tabController.dispose();

    super.dispose();
  }

  void _setCurrentIndex() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  Widget _buildBody(UserData user) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        controller: _denController,
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: DenAppbar(
                expandedHeight: MediaQuery.of(context).size.height * .1,
                heading: user.user.username,
              ),
              floating: true,
              pinned: true,
            ),
            JuntoDenSliverAppbar(
              profile: user,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: JuntoAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelPadding: const EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: Theme.of(context).primaryColorDark,
                  unselectedLabelColor: Theme.of(context).primaryColorLight,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  indicatorWeight: 0.0001,
                  tabs: <Widget>[
                    for (String name in _tabs) TabBarName(name: name),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            UserExpressions(
              privacy: 'Public',
              userProfile: user.user,
              rootExpressions: true,
              subExpressions: false,
              communityCenterFeedback: false,
            ),
            UserExpressions(
              privacy: 'Public',
              userProfile: user.user,
              rootExpressions: true,
              subExpressions: false,
              communityCenterFeedback: true,
            ),
            UserExpressions(
              privacy: 'Public',
              userProfile: user.user,
              rootExpressions: false,
              subExpressions: true,
              communityCenterFeedback: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, UserDataProvider user, Widget child) {
        return FeatureDiscovery(
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (value) => hideOrShowFab(value, _isVisible),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DenBloc>(
                    create: (context) => DenBloc(
                          Provider.of<UserRepo>(context, listen: false),
                          Provider.of<UserDataProvider>(context, listen: false),
                          Provider.of<ExpressionRepo>(context, listen: false),
                        )),
                BlocProvider<ChannelFilteringBloc>(
                  create: (ctx) => ChannelFilteringBloc(
                    RepositoryProvider.of<SearchRepo>(ctx),
                    (value) => BlocProvider.of<DenBloc>(ctx).add(
                      LoadDen(
                        user.userAddress,
                        {
                          'rootExpressions': true,
                          'subExpressions': false,
                          'communityFeedback': false,
                        },
                        channels: value != null ? [value.name] : null,
                      ),
                    ),
                  ),
                ),
              ],
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: JuntoFilterDrawer(
                  leftDrawer: const FilterDrawerContent(
                    ExpressionContextType.Collective,
                  ),
                  rightMenu: JuntoDrawer(),
                  scaffold: Scaffold(
                    floatingActionButton:
                        DenActionButton(isVisible: _isVisible, user: user),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    body: _buildBody(user.userProfile),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DenActionButton extends StatelessWidget {
  const DenActionButton({
    Key key,
    @required this.isVisible,
    @required this.user,
  }) : super(key: key);

  final ValueNotifier<bool> isVisible;
  final UserDataProvider user;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (context, visible, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          source: Screen.den,
        ),
      ),
    );
  }
}
