import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

import 'bloc/circle_bloc.dart';
import 'circles_appbar.dart';
import 'circles_list_all.dart';
import 'circles_requests.dart';

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

  @override
  void initState() {
    super.initState();
    circlesPageController = PageController(initialPage: 0);

    context.bloc<CircleBloc>().add(FetchMyCircle());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
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
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: BlocBuilder<CircleBloc, CircleState>(
            builder: (context, state) {
              return PageView(
                controller: circlesPageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  CirclesListAll(
                    userProfile: _userProfile,
                  ),
                  CirclesRequests(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
