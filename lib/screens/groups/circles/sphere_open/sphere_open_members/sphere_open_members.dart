import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';

import 'sphere_add_members.dart';

class SphereOpenMembers extends StatefulWidget {
  const SphereOpenMembers({
    Key key,
    @required this.group,
    this.relationToGroup,
  }) : super(key: key);

  final Group group;
  final Map<String, dynamic> relationToGroup;

  @override
  _SphereOpenMembersState createState() => _SphereOpenMembersState();
}

class _SphereOpenMembersState extends State<SphereOpenMembers>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = <String>['Facilitators', 'Members'];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(
      builder: (context, state) {
        if (state is CircleLoaded) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  brightness: Theme.of(context).brightness,
                  elevation: 0,
                  titleSpacing: 0,
                  title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            color: Colors.transparent,
                            width: 42,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              CustomIcons.back,
                              color: Theme.of(context).primaryColorDark,
                              size: 17,
                            ),
                          ),
                        ),
                        if (widget.relationToGroup != null &&
                            ((widget.relationToGroup['creator'] ||
                                    widget.relationToGroup['facilitator']) ||
                                (widget.relationToGroup['member'])))
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      SphereAddMembers(
                                    group: widget.group,
                                    permission: 'Member',
                                    members: state.members,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                CustomIcons.add,
                                color: Theme.of(context).primaryColorDark,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(.75),
                    child: Container(
                      height: .75,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: .75,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
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
                            controller: _tabController,
                            labelPadding: const EdgeInsets.all(0),
                            isScrollable: true,
                            labelColor: Theme.of(context).primaryColorDark,
                            unselectedLabelColor:
                                Theme.of(context).primaryColorLight,
                            labelStyle: Theme.of(context).textTheme.subtitle1,
                            indicatorWeight: 0.0001,
                            tabs: <Widget>[
                              for (String name in _tabs)
                                Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    right: 20,
                                  ),
                                  child: Text(
                                    name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
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
                    controller: _tabController,
                    children: <Widget>[
                      // Circle Facilitators
                      CircleFacilitators(
                        creator: state.creator?.user,
                        users: state.members ?? [],
                        group: widget.group,
                        relationToGroup: widget.relationToGroup,
                      ),
                      // All Circle Members
                      CircleMembers(
                        creator: state.creator?.user,
                        users: state.members ?? [],
                        group: widget.group,
                        relationToGroup: widget.relationToGroup,
                      ),
                    ],
                  ),
                ),
              ));
        }
        return Expanded(
          child: Center(
            child: Transform.translate(
              offset: const Offset(0.0, -50),
              child: JuntoProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class CircleFacilitators extends StatelessWidget {
  const CircleFacilitators({
    this.creator,
    this.users,
    this.relationToGroup,
    this.group,
  });

  final UserProfile creator;
  final List<Users> users;
  final Map<String, dynamic> relationToGroup;
  final Group group;

  @override
  Widget build(BuildContext context) {
    // Circle Facilitators (Admins)
    final isCreator = relationToGroup != null && relationToGroup['creator'];

    final list = [
      if (creator != null) Users(user: creator, permissionLevel: 'Admin'),
      ...users
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        if (list[index].permissionLevel == 'Admin') {
          return Slidable(
            actionPane: SlidableBehindActionPane(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MemberPreview(
                profile: list[index].user,
              ),
            ),
            actionExtentRatio: 0.20,
            secondaryActions: [
              if (isCreator && creator.address != list[index].user.address)
                IconSlideAction(
                  caption: 'Member',
                  color: Colors.indigo,
                  icon: Icons.supervisor_account_sharp,
                  onTap: () {
                    context.bloc<CircleBloc>().add(
                          UpdateMembersPermission(
                            sphereAdress: group.address,
                            user: list[index].user,
                            permissionLevel: 'Member',
                          ),
                        );
                  },
                ),
              if (isCreator && creator.address != list[index].user.address)
                IconSlideAction(
                  caption: 'Remove',
                  color: Colors.red,
                  icon: Icons.remove_circle,
                  onTap: () {
                    context.bloc<CircleBloc>().add(
                          RemoveMemberFromCircle(
                            sphereAdress: group.address,
                            userAddress: list[index].user.address,
                          ),
                        );
                  },
                ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class CircleMembers extends StatefulWidget {
  const CircleMembers({
    this.creator,
    this.users,
    this.group,
    this.relationToGroup,
  });

  final UserProfile creator;
  final List<Users> users;
  final Group group;
  final Map<String, dynamic> relationToGroup;

  @override
  _CircleMembersState createState() => _CircleMembersState();
}

class _CircleMembersState extends State<CircleMembers> {
  double position = 0.0;

  double sensitivityFactor = 20.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // All Circle Members
    final showSlide = widget.relationToGroup != null &&
        (widget.relationToGroup['creator'] ||
            widget.relationToGroup['facilitator']);
    final isCreator =
        widget.relationToGroup != null && widget.relationToGroup['creator'];

    final list = [
      if (widget.creator != null)
        Users(user: widget.creator, permissionLevel: 'Admin'),
      ...widget.users
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final metrics = notification.metrics;
        double scrollPercent = (metrics.pixels / metrics.maxScrollExtent) * 100;

        if (notification.metrics.pixels - position >= sensitivityFactor) {
          position = notification.metrics.pixels;
          if (scrollPercent.toInt() == 80) {
            context.read<CircleBloc>().add(
                LoadCircleMembersMore(sphereAddress: widget.group.address));

            return true;
          }
        }

        if (position - notification.metrics.pixels >= sensitivityFactor) {
          position = notification.metrics.pixels;
        }

        return false;
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableBehindActionPane(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MemberPreview(
                profile: list[index].user,
              ),
            ),
            actionExtentRatio: 0.20,
            secondaryActions: [
              if (showSlide &&
                  list[index].permissionLevel != 'Admin' &&
                  isCreator)
                IconSlideAction(
                  caption: 'Facilitator',
                  color: Colors.indigo,
                  icon: Icons.supervisor_account_sharp,
                  onTap: () {
                    context.bloc<CircleBloc>().add(
                          UpdateMembersPermission(
                            sphereAdress: widget.group.address,
                            user: list[index].user,
                            permissionLevel: 'Admin',
                          ),
                        );
                  },
                ),
              if (showSlide && list[index].permissionLevel != 'Admin')
                IconSlideAction(
                  caption: 'Remove',
                  color: Colors.red,
                  icon: Icons.remove_circle,
                  onTap: () {
                    context.bloc<CircleBloc>().add(
                          RemoveMemberFromCircle(
                            sphereAdress: widget.group.address,
                            userAddress: list[index].user.address,
                          ),
                        );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
