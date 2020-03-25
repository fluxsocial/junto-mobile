import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs_list.dart';
import 'package:junto_beta_mobile/screens/groups/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

// This screen displays groups a member belongs to. Currently, there are two types of
// groups: spheres (communities) and packs (agent-centric communities)
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
  GlobalKey<JuntoFilterDrawerState> _filterDrawerKey;

  bool actionsVisible = false;
  Widget _currentGroup;
  bool spheresVisible = false;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    try {
      final Group group = await Provider.of<GroupRepo>(context, listen: false)
          .getGroup(widget.initialGroup);

      if (group.groupType == 'Pack') {
        setState(() {
          _currentGroup = PackOpen(
            key: ValueKey<String>(group.address),
            pack: group,
          );
          isLoading = false;
        });
      } else if (group.groupType == 'Sphere') {
        setState(() {
          _currentGroup = SphereOpen(
            key: ValueKey<String>(group.address),
            group: group,
          );
        });
      }
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: Scaffold(
        body: JuntoFilterDrawer(
          key: _filterDrawerKey,
          leftDrawer: const FilterDrawerContent(ExpressionContextType.Group),
          rightMenu: JuntoDrawer(),
          scaffold: Scaffold(
            floatingActionButton: ValueListenableBuilder<bool>(
              valueListenable: _isVisible,
              builder: (BuildContext context, bool visible, Widget child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: visible ? 1.0 : 0.0,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: BottomNav(
                    address: widget.initialGroup,
                    expressionContext: ExpressionContext.Group,
                    actionsVisible: actionsVisible,
                    onLeftButtonTap: () {
                      if (actionsVisible) {
                        setState(() {
                          actionsVisible = false;
                        });
                      } else {
                        setState(() {
                          actionsVisible = true;
                        });
                      }
                    }),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Stack(
              children: <Widget>[
                if (isLoading) JuntoLoader(),
                if (!isLoading)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: actionsVisible ? 0.0 : 1.0,
                    child: _currentGroup,
                  ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: actionsVisible ? 1.0 : 0.0,
                  child: Visibility(
                    visible: actionsVisible,
                    child: PacksList(
                      selectedGroup: _changeGroup,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeGroup(Group group) {
    if (group.groupType == 'Pack') {
      setState(() {
        _currentGroup = PackOpen(
          key: ValueKey<String>(group.address),
          pack: group,
        );
        spheresVisible = false;
      });
    }

    if (group.groupType == 'Sphere') {
      setState(() {
        _currentGroup = const SizedBox();
      });
      setState(() {
        _currentGroup = SphereOpen(
          key: ValueKey<String>(group.address),
          group: group,
        );
      });
      spheresVisible = true;
    }

    actionsVisible = false;
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      //TODO: use proper context for groups
      BlocProvider<CollectiveBloc>(
        create: (ctx) =>
            CollectiveBloc(Provider.of<ExpressionRepo>(ctx, listen: false))
              ..add(
                FetchCollective(
                  ExpressionQueryParams(
                    contextType: ExpressionContextType.Collective,
                  ),
                ),
              ),
      ),
      BlocProvider<GroupBloc>(
          create: (ctx) => GroupBloc(
                Provider.of<GroupRepo>(ctx, listen: false),
                Provider.of<UserDataProvider>(ctx, listen: false),
                Provider.of<NotificationRepo>(ctx, listen: false),
              )..add(FetchMyPack())),
      BlocProvider<ChannelFilteringBloc>(
        create: (ctx) => ChannelFilteringBloc(
          Provider.of<SearchRepo>(ctx, listen: false),
          (value) => BlocProvider.of<GroupBloc>(ctx).add(
            FetchMyPack(
                // ExpressionQueryParams(
                //   contextType: ExpressionContextType.Collective,
                //   channels: [value.name],
                // ),
                ),
          ),
        ),
      ),
    ];
  }
}
