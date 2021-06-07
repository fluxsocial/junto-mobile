import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/bloc/relations/relation_bloc.dart';
import 'package:junto_beta_mobile/app/theme/custom_icons.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:provider/provider.dart';

class EditPerspectiveAddMembers extends StatefulWidget {
  const EditPerspectiveAddMembers({
    this.perspective,
    this.refreshPerspectiveMembers,
    this.perspectiveMembers,
  });

  final PerspectiveModel perspective;
  final Function refreshPerspectiveMembers;
  final List<UserProfile> perspectiveMembers;

  @override
  State<StatefulWidget> createState() {
    return EditPerspectiveAddMembersState();
  }
}

class EditPerspectiveAddMembersState extends State<EditPerspectiveAddMembers>
    with ListDistinct {
  final List<String> _tabs = <String>['Subscriptions', 'Connections'];
  final List<String> _perspectiveMembers = <String>[];

  @override
  void initState() {
    super.initState();
    context.read<RelationBloc>().add(
          FetchRealtionship(
              [RelationContext.following, RelationContext.connections], ''),
        );
  }

  Future<void> addMembersToPerspective() async {
    if (_perspectiveMembers.isNotEmpty) {
      JuntoLoader.showLoader(context);
      logger.logDebug(_perspectiveMembers.toString());
      try {
        await Provider.of<UserRepo>(context, listen: false)
            .addUsersToPerspective(
                widget.perspective.address, _perspectiveMembers);
        Navigator.pop(context);
        widget.refreshPerspectiveMembers();
        JuntoLoader.hide();
      } catch (e, s) {
        logger.logException(e, s);
        JuntoLoader.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
            brightness: Theme.of(context).brightness,
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            titleSpacing: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: .75,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).dividerColor,
              ),
            ),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Icon(CustomIcons.back, size: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: addMembersToPerspective,
                    child: Container(
                        height: 45,
                        width: 45,
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                  final memberList =
                      widget.perspectiveMembers.map((e) => e.address).toList();

                  // get list of connections
                  final List<UserProfile> _connectionsMembers =
                      state.connections;
                  final _filteredConnectionsMembers = _connectionsMembers.where(
                      (element) => !memberList.contains(element.address));

                  // get list of following
                  final List<UserProfile> _followingMembers = state.following;
                  final _filteredFollowingMembers = _followingMembers.where(
                      (element) => !memberList.contains(element.address));
                  return TabBarView(
                    children: <Widget>[
                      // subscriptions
                      if (_filteredFollowingMembers.length > 0)
                        NotificationListener<ScrollNotification>(
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
                                    '',
                                  ));
                              return true;
                            }
                            return false;
                          },
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: _filteredFollowingMembers
                                .map(
                                  (dynamic connection) => MemberPreviewSelect(
                                    profile: connection,
                                    onSelect: (UserProfile user) {
                                      setState(() {
                                        _perspectiveMembers.add(user.address);
                                      });
                                    },
                                    onDeselect: (UserProfile user) {
                                      setState(() {
                                        _perspectiveMembers
                                            .remove(user.address);
                                      });
                                    },
                                    isSelected: _perspectiveMembers
                                        .contains(connection.address),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      else
                        FeedPlaceholder(
                          placeholderText: memberList.length > 0
                              ? 'No more subscriptions to add'
                              : 'No subscriptions yet!',
                          image: 'assets/images/junto-mobile__bench.png',
                        ),
                      // connections
                      if (_filteredConnectionsMembers.length > 0)
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
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
                                    '',
                                  ));
                              return true;
                            }
                            return false;
                          },
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: _filteredConnectionsMembers
                                .map(
                                  (dynamic connection) => MemberPreviewSelect(
                                    profile: connection,
                                    onSelect: (UserProfile user) {
                                      setState(() {
                                        _perspectiveMembers.add(user.address);
                                      });
                                    },
                                    onDeselect: (UserProfile user) {
                                      setState(() {
                                        _perspectiveMembers
                                            .remove(user.address);
                                      });
                                    },
                                    isSelected: _perspectiveMembers
                                        .contains(connection.address),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      else
                        FeedPlaceholder(
                          placeholderText: memberList.length > 0
                              ? 'No more connections to add'
                              : 'No connections yet!',
                          image: 'assets/images/junto-mobile__bench.png',
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
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator(),
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -50),
                        child: JuntoProgressIndicator(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
