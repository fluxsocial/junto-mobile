import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_about.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/circle_open_expressions/circle_open_expressions.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';
import 'package:junto_beta_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

import 'circle_action_buttons.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    this.group,
  }) : super(key: key);

  final Group group;

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
  final ValueNotifier<bool> shouldRefresh = ValueNotifier<bool>(true);
  Map<String, dynamic> relationToGroup;
  Future<QueryResults<ExpressionResponse>> getExpressions;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userAddress = Provider.of<UserDataProvider>(context).userAddress;
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
    _loadRelationship();
    setGetExpressions();
  }

  void setGetExpressions() {
    setState(() {
      getExpressions = Provider.of<ExpressionRepo>(context, listen: false)
          .getCollectiveExpressions({
        'context': widget.group.address,
        'context_type': 'Group',
        'pagination_position': '0',
      });
    });
  }

  void deleteExpression(ExpressionResponse expression) async {
    await Provider.of<ExpressionRepo>(context, listen: false)
        .deleteExpression(expression.address);
    // refresh feed
    setGetExpressions();
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          group: widget.group,
        ),
      ),
      floatingActionButton: CircleActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              SphereOpenAbout(
                group: widget.group,
              ),
              if (widget.group.address != null)
                CircleOpenExpressions(
                    getExpressions: getExpressions,
                    deleteExpression: deleteExpression),
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
                      if (widget.group.groupData.photo == '')
                        CircleBackgroundPlaceholder()
                      else
                        CircleBackground(
                          photo: widget.group.groupData.photo,
                        ),
                      Container(
                        key: _keyFlexibleSpace,
                        padding: const EdgeInsets.symmetric(
                            horizontal: JuntoStyles.horizontalPadding,
                            vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.group.groupData.name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            if (relationToGroup != null &&
                                !relationToGroup['creator'] &&
                                !relationToGroup['member'] &&
                                !relationToGroup['facilitator'])
                              JoinCircleWidget(
                                groupAddress: widget.group.address,
                                userProfile: _userProfile.user,
                              )
                            else
                              ShowRelationshipWidget(
                                relationToGroup: relationToGroup,
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
                    unselectedLabelColor: Theme.of(context).primaryColorLight,
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
        CustomIcons.spheres,
        size: 60,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class JoinCircleWidget extends StatelessWidget {
  const JoinCircleWidget({this.groupAddress, this.userProfile});

  final String groupAddress;
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<GroupRepo>(context, listen: false).addGroupMember(
          groupAddress,
          <UserProfile>[userProfile],
          'Member',
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
  const ShowRelationshipWidget({this.relationToGroup});
  final Map<String, dynamic> relationToGroup;

  @override
  Widget build(BuildContext context) {
    String relation;

    if (relationToGroup == null) {
      relation = 'Member';
    } else if (relationToGroup['creator'] || relationToGroup['facilitator']) {
      relation = 'Facilitator';
    } else if (relationToGroup['member']) {
      relation = 'Member';
    } else {
      relation = 'Member';
    }
    return GestureDetector(
      onTap: () {
        // Open panel for group action items
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
