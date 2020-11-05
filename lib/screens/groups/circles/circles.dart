import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

import 'circles_list_all.dart';
import 'circles_appbar.dart';

// This screen displays the temporary page we'll display until groups are released
class Circles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CirclesState();
  }
}

class CirclesState extends State<Circles> with ListDistinct {
  PageController circlesPageController;
  int _currentIndex = 0;
  UserData _userProfile;
  GroupRepo _userProvider;

  @override
  void initState() {
    super.initState();
    circlesPageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<GroupRepo>(context, listen: false);
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
  }

  Future<UserGroupsResponse> getUserGroups() async {
    final userGroups = _userProvider.getUserGroups(_userProfile.user.address);
    return userGroups;
  }

  void changePageView(int index) {
    circlesPageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        leftDrawer: null,
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * .1 + 50,
            ),
            child: CirclesAppbar(
              currentIndex: _currentIndex,
              changePageView: changePageView,
            ),
          ),
          floatingActionButton: BottomNav(
            address: null,
            expressionContext: ExpressionContext.Group,
            source: Screen.groups,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: PageView(
            controller: circlesPageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              CirclesListAll(
                userProfile: _userProfile,
                getUserGroups: getUserGroups,
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}