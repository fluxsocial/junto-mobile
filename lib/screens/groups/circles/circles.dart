import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed_new.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_handler.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:provider/provider.dart';

import 'bloc/circle_bloc.dart';
import 'circles_appbar.dart';
import 'circles_list_all.dart';
import 'circles_requests.dart';
import 'private_groups_placeholder.dart';
import 'public_circles.dart';
import 'sphere_open/sphere_open.dart';

// This screen displays the temporary page we'll display until groups are released
class Circles extends StatefulWidget {
  const Circles({
    Key key,
    this.group,
  }) : super(key: key);

  final Group group;
  @override
  State<StatefulWidget> createState() {
    return CirclesState();
  }
}

class CirclesState extends State<Circles>
    with ListDistinct, TickerProviderStateMixin {
  PageController circlesPageController;
  UserData _userProfile;
  int _currentIndex = 0;
  // Group activeGroup;

  @override
  void initState() {
    super.initState();
    circlesPageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
    final groupsPageIndex =
        Provider.of<AppRepo>(context, listen: false).groupsPageIndex;
    _currentIndex = groupsPageIndex;
    circlesPageController = PageController(initialPage: groupsPageIndex);
  }

  bool onWillPop() {
    if (circlesPageController.page.round() == 0) {
      return true;
    } else {
      circlesPageController.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: JuntoFilterDrawer(
          leftDrawer: null,
          rightMenu: null,
          swipe: false,
          scaffold: PageView(
            controller: circlesPageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
              Provider.of<AppRepo>(context, listen: false)
                  .setGroupsPageIndex(index);
            },
            children: [
              CircleMain(
                userProfile: _userProfile,
                widget: widget,
                onGroupSelected: (Group group) async {
                  circlesPageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                  await Provider.of<AppRepo>(context, listen: false)
                      .setActiveGroup(group);
                },
              ),
              if (widget.group != null && widget.group.address == null)
                Scaffold(body: ExpressionFeed(goBack: () {
                  circlesPageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                }))
              else
                SphereOpen(
                  group: widget.group,
                  goBack: () {
                    circlesPageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeIn,
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleMain extends StatefulWidget {
  const CircleMain({
    Key key,
    @required UserData userProfile,
    @required this.widget,
    this.onGroupSelected,
  })  : _userProfile = userProfile,
        super(key: key);

  final UserData _userProfile;
  final Circles widget;
  final Function(Group) onGroupSelected;

  @override
  _CircleMainState createState() => _CircleMainState();
}

class _CircleMainState extends State<CircleMain>
    with AutomaticKeepAliveClientMixin {
  PageController circlesPageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    circlesPageController = PageController(initialPage: 0);
  }

  void changePageView(int index) {
    circlesPageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  bool onWillPop() {
    if (circlesPageController.page.round() ==
        circlesPageController.initialPage) {
      return false;
    } else {
      circlesPageController.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * .1 + 50,
        ),
        child: CirclesAppbar(
          changePageView: changePageView,
          currentIndex: _currentIndex,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: BlocBuilder<CircleBloc, CircleState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(bottom: 75),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: circlesPageController,
                      onPageChanged: (int index) async {
                        setState(() {
                          _currentIndex = index;
                        });

                        if (index == 2) {
                          Provider.of<NotificationsHandler>(context,
                                  listen: false)
                              .fetchNotifications();
                        }
                      },
                      children: [
                        PublicCircles(
                          userProfile: widget._userProfile,
                          onGroupSelected: widget.onGroupSelected,
                        ),
                        CirclesListAll(
                          userProfile: widget._userProfile,
                          onGroupSelected: widget.onGroupSelected,
                        ),
                        PrivateGroupsPlaceholder(),
                        CirclesRequests(
                          onGroupSelected: widget.onGroupSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
