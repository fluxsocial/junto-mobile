import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/search_bar.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/screens/global_search/relations_bloc/relation_bloc.dart';
import 'create_sphere_search.dart';

class CreateSpherePageTwo extends StatefulWidget {
  const CreateSpherePageTwo({
    Key key,
    @required this.addMember,
    @required this.removeMember,
    @required this.selectedMembers,
  }) : super(key: key);
  final ValueChanged<UserProfile> addMember;
  final ValueChanged<UserProfile> removeMember;
  final List<String> selectedMembers;

  @override
  _CreateSpherePageTwoState createState() => _CreateSpherePageTwoState();
}

class _CreateSpherePageTwoState extends State<CreateSpherePageTwo> {
  TextEditingController _subController;
  TextEditingController _conController;
  final List<String> _tabs = <String>[
    'All',
    'Subscriptions',
    'Connections',
  ];

  @override
  void initState() {
    super.initState();

    _subController = TextEditingController();
    _conController = TextEditingController();

    context
        .read<RelationBloc>()
        .add(FetchRealtionship(RelationContext.following, ''));
    context
        .read<RelationBloc>()
        .add(FetchRealtionship(RelationContext.connections, ''));
  }

  @override
  void dispose() {
    _subController.dispose();
    _conController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
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
                    for (String name in _tabs)
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        color: Theme.of(context).colorScheme.background,
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            CreateSphereSearch(
              onSelect: widget.addMember,
              onDeselect: widget.removeMember,
              selectedMembers: widget.selectedMembers,
            ),
            // Subscriptions

            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: SearchBar(
                      hintText: 'Search',
                      textEditingController: _subController,
                      onTextChange: (val) {
                        context.read<RelationBloc>().add(
                            FetchRealtionship(RelationContext.following, val));
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<RelationBloc, RelationState>(
                        builder: (context, state) {
                      if (state is RelationErrorState) {
                        print(state.message);
                        return Center(
                          child: JuntoErrorWidget(
                              errorMessage: 'Hmm, something went wrong'),
                        );
                      } else if (state is RelationLoadingState) {
                        return Center(
                          child: JuntoProgressIndicator(),
                        );
                      } else if (state is RelationLoadedState) {
                        // get list of following
                        final List<UserProfile> _followingMembers =
                            state.following;
                        if (_followingMembers.length > 0) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              final metrics = notification.metrics;
                              double scrollPercent =
                                  (metrics.pixels / metrics.maxScrollExtent) *
                                      100;
                              if (scrollPercent.roundToDouble() == 60.0 &&
                                  state.followingResultCount >
                                      _followingMembers.length) {
                                context
                                    .read<RelationBloc>()
                                    .add(FetchMoreRelationship(
                                      RelationContext.following,
                                      _subController.value.text,
                                    ));
                                return true;
                              }
                              return false;
                            },
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              children: <Widget>[
                                for (UserProfile member in _followingMembers)
                                  MemberPreviewSelect(
                                    profile: member,
                                    onSelect: widget.addMember,
                                    onDeselect: widget.removeMember,
                                    isSelected: widget.selectedMembers
                                        .contains(member.address),
                                  ),
                              ],
                            ),
                          );
                        }
                      }
                      return Center(
                        child: JuntoProgressIndicator(),
                      );
                    }),
                  )
                ],
              ),
            ),
            // Connections
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: SearchBar(
                      hintText: 'Search',
                      textEditingController: _conController,
                      onTextChange: (val) {
                        context.read<RelationBloc>().add(FetchRealtionship(
                            RelationContext.connections, val));
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<RelationBloc, RelationState>(
                      builder: (context, state) {
                        if (state is RelationErrorState) {
                          print(state.message);
                          return Center(
                            child: JuntoErrorWidget(
                                errorMessage: 'Hmm, something went wrong'),
                          );
                        } else if (state is RelationLoadingState) {
                          return Center(
                            child: JuntoProgressIndicator(),
                          );
                        } else if (state is RelationLoadedState) {
                          // get list of connections
                          final List<UserProfile> _connectionsMembers =
                              state.connections;

                          if (_connectionsMembers.length > 0) {
                            return NotificationListener<ScrollNotification>(
                              onNotification:
                                  (ScrollNotification notification) {
                                final metrics = notification.metrics;
                                double scrollPercent =
                                    (metrics.pixels / metrics.maxScrollExtent) *
                                        100;
                                if (scrollPercent.roundToDouble() == 60.0 &&
                                    state.connctionResultCount >
                                        _connectionsMembers.length) {
                                  context
                                      .read<RelationBloc>()
                                      .add(FetchMoreRelationship(
                                        RelationContext.connections,
                                        _conController.value.text,
                                      ));
                                  return true;
                                }
                                return false;
                              },
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                children: <Widget>[
                                  for (UserProfile connection
                                      in _connectionsMembers)
                                    MemberPreviewSelect(
                                      profile: connection,
                                      onSelect: widget.addMember,
                                      onDeselect: widget.removeMember,
                                      isSelected: widget.selectedMembers
                                          .contains(connection.address),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return FeedPlaceholder(
                              placeholderText: 'No connections yet!',
                              image: 'assets/images/junto-mobile__bench.png',
                            );
                          }
                        } else {
                          return Center(
                            child: JuntoProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
