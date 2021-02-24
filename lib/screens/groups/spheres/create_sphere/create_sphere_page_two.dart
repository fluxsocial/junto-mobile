import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/screens/global_search/relations_bloc/relation_bloc.dart';

class CreateSpherePageTwo extends StatefulWidget {
  const CreateSpherePageTwo({
    Key key,
    @required this.tabs,
    @required this.addMember,
    @required this.removeMember,
  }) : super(key: key);
  final List<String> tabs;
  final ValueChanged<UserProfile> addMember;
  final ValueChanged<UserProfile> removeMember;

  @override
  _CreateSpherePageTwoState createState() => _CreateSpherePageTwoState();
}

class _CreateSpherePageTwoState extends State<CreateSpherePageTwo> {
  @override
  void initState() {
    super.initState();
    context
        .bloc<RelationBloc>()
        .add(FetchRealtionship(RelationContext.following));
    context
        .bloc<RelationBloc>()
        .add(FetchRealtionship(RelationContext.connections));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: JuntoAppBarDelegate(
                TabBar(
                  labelPadding: const EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: Theme.of(context).primaryColorDark,
                  labelStyle: Theme.of(context).textTheme.subtitle1,
                  indicatorWeight: 0.0001,
                  tabs: <Widget>[
                    for (String name in widget.tabs)
                      Container(
                        margin: const EdgeInsets.only(right: 24),
                        color: Theme.of(context).colorScheme.background,
                        child: Tab(
                          text: name,
                        ),
                      ),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: BlocBuilder<RelationBloc, RelationState>(
          builder: (context, state) {
            if (state is RelationLoadedState) {
              // get list of connections
              final List<UserProfile> _connectionsMembers = state.connections;

              // get list of following
              final List<UserProfile> _followingMembers = state.following;

              return TabBarView(
                children: <Widget>[
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      final metrics = notification.metrics;
                      double scrollPercent =
                          (metrics.pixels / metrics.maxScrollExtent) * 100;
                      if (scrollPercent.roundToDouble() == 60.0 &&
                          state.followingResultCount >
                              _followingMembers.length) {
                        context.bloc<RelationBloc>().add(FetchMoreRelationship(
                              RelationContext.following,
                            ));
                        return true;
                      }
                      return false;
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        for (UserProfile member in _followingMembers)
                          MemberPreviewSelect(
                            profile: member,
                            onSelect: widget.addMember,
                            onDeselect: widget.removeMember,
                            isSelected: false, //TODO: Update with dynamic val
                          ),
                      ],
                    ),
                  ),
                  // connections
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      final metrics = notification.metrics;
                      double scrollPercent =
                          (metrics.pixels / metrics.maxScrollExtent) * 100;
                      if (scrollPercent.roundToDouble() == 60.0 &&
                          state.connctionResultCount >
                              _connectionsMembers.length) {
                        context.bloc<RelationBloc>().add(FetchMoreRelationship(
                              RelationContext.connections,
                            ));
                        return true;
                      }
                      return false;
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        for (UserProfile connection in _connectionsMembers)
                          MemberPreviewSelect(
                            profile: connection,
                            onSelect: widget.addMember,
                            onDeselect: widget.removeMember,
                            isSelected: false, //TODO: Update with dynamic val
                          ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is RelationErrorState) {
              return TabBarView(
                children: <Widget>[
                  Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ),
                  Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: Text('Hmmm, something is up',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ),
                ],
              );
            }
            return TabBarView(
              children: <Widget>[
                Center(
                  child: JuntoProgressIndicator(),
                ),
                Center(
                  child: JuntoProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
