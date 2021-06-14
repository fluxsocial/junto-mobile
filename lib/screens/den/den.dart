import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/app/material_app_with_theme.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/dialogs/url_dialog.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar_name.dart';

import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    'Replies',
  ];

  @override
  void initState() {
    super.initState();

    _denController = ScrollController();
    _tabController = TabController(
      vsync: this,
      initialIndex: 0,
      length: _tabs.length,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      configureDenOpened();
    });
  }

  Future<void> configureDenOpened() async {
    try {
      final appRepo = Provider.of<AppRepo>(context, listen: false);
      final isOpened = await appRepo.isDenOpened();
      print('test: $isOpened');
      if (!isOpened) {
        Timer(Duration(seconds: 1), () {
          showDialog(
            context: context,
            builder: (BuildContext context) => UrlDialog(
              context: context,
              text: "Fill out this form for if you were a crowdfunder",
              urlText: "Fill form",
              onTap: () async {
                // TODO: need to update the url
                final url = "https://junto.typeform.com/";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
          );
        });
        await appRepo.setDenOpened();
        return;
      } else {
        return;
      }
    } catch (e) {
      print('test: $e');
      logger.logException(e, null, "Error configuring notifications");
    }
  }

  @override
  void dispose() {
    _denController.dispose();
    _tabController.dispose();

    super.dispose();
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
                expandedHeight: MediaQuery.of(context).size.height * .06,
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
            UserExpressProvider(
              address: user.user.address,
              child: UserExpressions(
                privacy: 'Public',
                userProfile: user.user,
                rootExpressions: true,
                subExpressions: false,
                communityCenterFeedback: false,
              ),
            ),
            UserExpressProvider(
              address: user.user.address,
              child: UserExpressions(
                privacy: 'Public',
                userProfile: user.user,
                rootExpressions: false,
                subExpressions: true,
                communityCenterFeedback: false,
              ),
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
            child: WillPopScope(
              onWillPop: () async {
                return Navigator.pushReplacement(
                      context,
                      FadeRoute(
                        child: HomePageContent(),
                      ),
                    ) ??
                    false;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: _buildBody(user.userProfile),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserExpressProvider extends StatelessWidget {
  final String address;
  final Widget child;

  const UserExpressProvider({
    Key key,
    @required this.address,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DenBloc>(
          create: (context) => DenBloc(
            Provider.of<UserRepo>(context, listen: false),
            Provider.of<UserDataProvider>(context, listen: false),
            Provider.of<ExpressionRepo>(context, listen: false),
          ),
        ),
      ],
      child: BlocListener<ChannelFilteringBloc, ChannelFilteringState>(
        listener: (context, state) {
          final channels = state.selectedChannel != null
              ? state.selectedChannel.map((e) => e.name).toList()
              : null;
          Map<String, dynamic> _param = {
            'rootExpressions': true,
            'subExpressions': false,
            'communityFeedback': false,
          };

          channels.forEach(
            (String channel) {
              _param.putIfAbsent(
                'channel${(channels.indexOf(channel) + 1).toString()}',
                () => channel,
              );
            },
          );
          BlocProvider.of<DenBloc>(context).add(
            LoadDen(
              address,
              _param,
              channels: channels,
            ),
          );
        },
        child: child,
      ),
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
      child: BottomNav(),
    );
  }
}
