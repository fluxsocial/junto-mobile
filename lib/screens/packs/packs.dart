import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/packs/packs_list.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoPacks extends StatefulWidget {
  const JuntoPacks({@required this.initialGroup});

  final String initialGroup;

  @override
  State<StatefulWidget> createState() {
    return JuntoPacksState();
  }
}

class JuntoPacksState extends State<JuntoPacks>
    with HideFab, ListDistinct, TickerProviderStateMixin {
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  int _currentIndex = 0;
  PageController _pageController;

  _packsViewNav() {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final packsPageIndex =
        Provider.of<AppRepo>(context, listen: false).packsPageIndex;
    _currentIndex = packsPageIndex;
    _pageController = PageController(initialPage: packsPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (value) => hideOrShowFab(value, _isVisible),
        child: MultiBlocProvider(
          providers: _getBlocProviders(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: JuntoFilterDrawer(
              leftDrawer: _currentIndex == 1
                  ? const FilterDrawerContent(ExpressionContextType.Group)
                  : null,
              rightMenu: JuntoDrawer(),
              scaffold: Scaffold(
                  body: PageView(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  Provider.of<AppRepo>(context, listen: false)
                      .setPacksPageIndex(index);
                },
                controller: _pageController,
                children: <Widget>[
                  PacksList(
                    packsViewNav: _packsViewNav,
                    isVisible: _isVisible,
                  ),
                  PackOpen(
                    packsViewNav: _packsViewNav,
                    isVisible: _isVisible,
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<GroupBloc>(
        create: (ctx) => GroupBloc(
          Provider.of<GroupRepo>(ctx, listen: false),
          Provider.of<UserDataProvider>(ctx, listen: false),
          Provider.of<NotificationRepo>(ctx, listen: false),
        )..add(FetchMyPack()),
        lazy: false,
      ),
      BlocProvider<PackBloc>(
        create: (ctx) => PackBloc(
          Provider.of<ExpressionRepo>(ctx, listen: false),
          Provider.of<GroupRepo>(ctx, listen: false),
          initialGroup: widget.initialGroup,
        )..add(FetchPacks()),
        lazy: false,
      ),
      BlocProvider<ChannelFilteringBloc>(
        create: (ctx) => ChannelFilteringBloc(
          Provider.of<SearchRepo>(ctx, listen: false),
          (value) => BlocProvider.of<PackBloc>(ctx).add(
            FetchPacks(channel: value?.name),
          ),
        ),
        lazy: false,
      ),
    ];
  }
}
