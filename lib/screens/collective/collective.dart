import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/collective_actions.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

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
  final ValueNotifier<String> _appbarTitle = ValueNotifier<String>('JUNTO');
  bool _actionsVisible = false;

  @override
  void initState() {
    super.initState();

    _collectiveController = ScrollController();
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
      _collectiveController.animateTo(0.0,
          duration: kTabScrollDuration, curve: Curves.decelerate);
    }
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, _isFabVisible);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: JuntoFilterDrawer(
          key: _filterDrawerKey,
          leftDrawer:
              const FilterDrawerContent(ExpressionContextType.Collective),
          rightMenu: JuntoDrawer(),
          scaffold: Scaffold(
            key: _juntoCollectiveKey,
            floatingActionButton: CollectiveActionButton(
              isVisible: _isFabVisible,
              actionsVisible: _actionsVisible,
              onUpTap: _scrollToTop,
              onTap: () {
                setState(() {
                  _actionsVisible = !_actionsVisible;
                });
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Stack(
              children: <Widget>[
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _actionsVisible ? 0.0 : 1.0,
                  child: ExpressionFeed(
                    collectiveController: _collectiveController,
                    appbarTitle: _appbarTitle,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _actionsVisible ? 1.0 : 0.0,
                  child: Visibility(
                    visible: _actionsVisible,
                    child:
                        JuntoCollectiveActions(onChanged: _changePerspective),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<CollectiveBloc>(
        create: (ctx) => CollectiveBloc(
          Provider.of<ExpressionRepo>(ctx, listen: false),
          () => Navigator.of(context).pushReplacement(Welcome.route()),
        )..add(
            FetchCollective(
              ExpressionQueryParams(ExpressionContextType.Collective, '0'),
            ),
          ),
      ),
      BlocProvider<PerspectivesBloc>(
        create: (ctx) => PerspectivesBloc(
          Provider.of<UserRepo>(ctx, listen: false),
          Provider.of<UserDataProvider>(ctx, listen: false),
        )..add(FetchPerspectives()),
        lazy: false,
      ),
      BlocProvider<ChannelFilteringBloc>(
        create: (ctx) => ChannelFilteringBloc(
          Provider.of<SearchRepo>(ctx, listen: false),
          (value) => BlocProvider.of<CollectiveBloc>(ctx).add(
            FetchCollective(
              ExpressionQueryParams(
                ExpressionContextType.Collective,
                '0',
                channels: value != null ? [value.name] : null,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // Switch between perspectives; used in perspectives side drawer.
  void _changePerspective(BuildContext context, PerspectiveModel perspective) {
    //TODO(dominik): implement switching via bloc
    if (perspective.name == 'JUNTO') {
      _appbarTitle.value = 'JUNTO';
      context.bloc<CollectiveBloc>().add(
            FetchCollective(
              ExpressionQueryParams(
                ExpressionContextType.Collective,
                '0',
              ),
            ),
          );
    } else if (perspective.name == 'Connections') {
      _appbarTitle.value = 'Connections';
      context.bloc<CollectiveBloc>().add(
            FetchCollective(
              ExpressionQueryParams(
                ExpressionContextType.ConnectPerspective,
                '0',
                dos: '0',
                context: perspective.address,
              ),
            ),
          );
    } else {
      setState(() {
        //TODO this may be wrong
        if (perspective.name.contains("'s Follow Perspective")) {
          _appbarTitle.value = 'Subscriptions';
        } else {
          _appbarTitle.value = perspective.name;
        }
      });

      context.bloc<CollectiveBloc>().add(
            FetchCollective(
              ExpressionQueryParams(
                ExpressionContextType.FollowPerspective,
                '0',
                dos: null,
                context: perspective.address,
              ),
            ),
          );
    }
    setState(() {
      _actionsVisible = false;
    });
  }
}
