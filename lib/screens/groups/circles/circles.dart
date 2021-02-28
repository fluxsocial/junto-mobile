import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed_new.dart';

import 'bloc/circle_bloc.dart';
import 'circles_appbar.dart';
import 'circles_list_all.dart';
import 'circles_requests.dart';
import 'sphere_open/sphere_open.dart';

// This screen displays the temporary page we'll display until groups are released
class Circles extends StatefulWidget {
  final Group group;

  const Circles({
    Key key,
    this.group,
  }) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: null,
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
            if (widget.group != null &&
                widget.group.address == 'junto-collective-group')
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

class _CircleMainState extends State<CircleMain> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * .1 + 50,
        ),
        child: CirclesAppbar(
          currentIndex: _currentIndex,
          changePageView: changePageView,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder<CircleBloc, CircleState>(
        builder: (context, state) {
          return CirclesListAll(
            userProfile: widget._userProfile,
            onGroupSelected: widget.onGroupSelected,
          );
        },
      ),
    );
  }
}
