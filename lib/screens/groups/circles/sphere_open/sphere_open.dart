import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_about.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/action_items/creator/circle_action_items_admin.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/action_items/member/circle_action_items_member.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/circle_open_expressions/circle_open_expressions.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    this.group,
    this.goBack,
  }) : super(key: key);

  final Group group;
  final Function goBack;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  final GlobalKey<SphereOpenState> _keyFlexibleSpace =
      GlobalKey<SphereOpenState>();

  String _userAddress;
  UserData _userProfile;
  double _flexibleHeightSpace;
  final List<String> _tabs = <String>['ABOUT', 'EXPRESSIONS'];
  Map<String, dynamic> relationToGroup;
  Future<QueryResults<ExpressionResponse>> getExpressions;
  UserProfile circleCreator;

  void _getFlexibleSpaceSize(_) {
    final RenderBox renderBoxFlexibleSpace =
        _keyFlexibleSpace.currentContext.findRenderObject();
    final Size sizeFlexibleSpace = renderBoxFlexibleSpace.size;
    final double heightFlexibleSpace = sizeFlexibleSpace.height;

    setState(() {
      _flexibleHeightSpace = heightFlexibleSpace;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getFlexibleSpaceSize);

    context
        .bloc<CircleBloc>()
        .add(LoadCircleMembers(sphereAddress: widget.group.address));

    context.bloc<CollectiveBloc>().add(
          FetchCollective(
            ExpressionQueryParams(
              context: widget.group.address,
              contextType: ExpressionContextType.Group,
            ),
          ),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userAddress = Provider.of<UserDataProvider>(context).userAddress;
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
    _loadRelationship();
  }

  loadCircleMembers() {
    context.bloc<CircleBloc>().add(
          LoadCircleMembers(sphereAddress: widget.group.address),
        );
  }

  Future<void> _loadRelationship() async {
    final Map<String, dynamic> _relationToGroup =
        await Provider.of<GroupRepo>(context, listen: false).getRelationToGroup(
      widget.group.address,
      _userAddress,
    );
    print(_relationToGroup);
    setState(() {
      relationToGroup = _relationToGroup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(builder: (context, state) {
      if (state is CircleLoaded) {
        final group = state.groups.firstWhere(
          (element) => element.address == widget.group.address,
          orElse: () => widget.group,
        );

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: SphereOpenAppbar(
              group: group,
              onBack: widget.goBack,
            ),
          ),
          body: DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              body: TabBarView(
                children: <Widget>[
                  SphereOpenAbout(
                    group: group,
                    circleCreator: state.creator?.user,
                    members: state.members,
                    relationToGroup: relationToGroup,
                    totalFacilitators: state.totalFacilitators,
                    totalMembers: state.totalMembers,
                  ),
                  if (group.address != null) CircleOpenExpressions(),
                ],
              ),
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (
                BuildContext context,
                bool innerBoxIsScrolled,
              ) {
                return <Widget>[
                  SliverAppBar(
                    brightness: Theme.of(context).brightness,
                    automaticallyImplyLeading: false,
                    primary: false,
                    actions: const <Widget>[
                      SizedBox(
                        height: 0,
                        width: 0,
                      ),
                    ],
                    backgroundColor: Theme.of(context).colorScheme.background,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        children: <Widget>[
                          if (group.groupData.photo == '')
                            CircleBackgroundPlaceholder()
                          else
                            CircleBackground(
                              photo: group.groupData.photo,
                            ),
                          Container(
                            key: _keyFlexibleSpace,
                            padding: const EdgeInsets.symmetric(
                              horizontal: JuntoStyles.horizontalPadding,
                              vertical: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    group.groupData.name,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                                if (relationToGroup != null &&
                                    !relationToGroup['creator'] &&
                                    !relationToGroup['member'] &&
                                    !relationToGroup['facilitator'])
                                  JoinCircleWidget(
                                    groupAddress: group.address,
                                    userProfile: _userProfile.user,
                                    loadRelationship: _loadRelationship,
                                    loadCircleMembers: loadCircleMembers,
                                  )
                                else
                                  ShowRelationshipWidget(
                                    circle: group,
                                    relationToGroup: relationToGroup,
                                    userProfile: _userProfile.user,
                                    members: state.members,
                                    circleCreator: state.creator?.user,
                                    goBack: widget.goBack,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: _flexibleHeightSpace == null
                        ? 10000
                        : MediaQuery.of(context).size.height * .3 +
                            _flexibleHeightSpace,
                    forceElevated: false,
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: JuntoAppBarDelegate(
                      TabBar(
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
                              margin: const EdgeInsets.only(right: 20),
                              color: Theme.of(context).colorScheme.background,
                              child: Tab(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ];
              },
            ),
          ),
        );
      }

      return Expanded(
        child: Center(
          child: Transform.translate(
            offset: const Offset(0.0, -50),
            child: JuntoProgressIndicator(),
          ),
        ),
      );
    });
  }
}

class CircleBackground extends StatelessWidget {
  const CircleBackground({this.photo});

  final String photo;
  @override
  Widget build(BuildContext context) {
    return ImageWrapper(
      imageUrl: photo,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .3,
      placeholder: (BuildContext context, String _) {
        return Container(
          color: Theme.of(context).dividerColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .3,
        );
      },
      fit: BoxFit.cover,
    );
  }
}

class CircleBackgroundPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.2, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        CustomIcons.newcollective,
        size: 80,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class JoinCircleWidget extends StatelessWidget {
  const JoinCircleWidget({
    this.groupAddress,
    this.userProfile,
    this.loadRelationship,
    this.loadCircleMembers,
  });

  final String groupAddress;
  final UserProfile userProfile;
  final loadRelationship;
  final loadCircleMembers;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          JuntoLoader.showLoader(context);
          // Accept request
          await Provider.of<GroupRepo>(context, listen: false)
              .respondToGroupRequest(
            groupAddress,
            true,
          );
          await loadCircleMembers();
          await loadRelationship();
          JuntoLoader.hide();
        } on DioError catch (e) {
          JuntoLoader.hide();
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleActionDialog(
              context: context,
              dialogText: 'Sorry, something went wrong. Please try again!',
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Text(
          'JOIN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class ShowRelationshipWidget extends StatelessWidget {
  const ShowRelationshipWidget({
    this.circle,
    this.relationToGroup,
    this.userProfile,
    this.members,
    this.circleCreator,
    this.goBack,
  });
  final Group circle;
  final Map<String, dynamic> relationToGroup;
  final UserProfile userProfile;
  final List<Users> members;
  final UserProfile circleCreator;
  final Function goBack;

  @override
  Widget build(BuildContext context) {
    String relation;
    Widget actionItems;

    if (relationToGroup == null) {
      relation = 'Join';
    } else if (relationToGroup['creator'] || relationToGroup['facilitator']) {
      relation = relationToGroup['creator'] ? 'Creator' : 'Facilitator';
      actionItems = CircleActionItemsAdmin(
        sphere: circle,
        userProfile: userProfile,
        isCreator: relationToGroup['creator'],
        goBack: goBack,
      );
    } else if (relationToGroup['member']) {
      relation = 'Member';
      actionItems = CircleActionItemsMember(
        sphere: circle,
        userProfile: userProfile,
        members: members,
        circleCreator: circleCreator,
        goBack: goBack,
      );
    } else {
      relation = 'Join';
      actionItems = CircleActionItemsMember(
        sphere: circle,
        userProfile: userProfile,
        members: members,
        circleCreator: circleCreator,
        goBack: goBack,
      );
    }

    return GestureDetector(
      onTap: () {
        // Open panel for group action items
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          builder: (BuildContext context) => Container(
            color: Colors.transparent,
            child: actionItems,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Text(
          relation,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
