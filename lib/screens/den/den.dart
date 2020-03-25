import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/screens/den/den_sliver_appbar.dart';
import 'package:junto_beta_mobile/widgets/appbar/den_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/user_expressions.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/member_widgets/about_member.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen>
    with HideFab, TickerProviderStateMixin {
  UserData _userProfile;
  String _currentTheme;

  bool showComments = false;

  ScrollController _denController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _denController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _denController.addListener(_onScrollingHasChanged);
      if (_denController.hasClients)
        _denController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    _denController.removeListener(_onScrollingHasChanged);
    _denController.dispose();
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_denController, _isVisible);
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userProfile = UserData.fromMap(decodedUserData);
      _currentTheme = prefs.getString('current-theme');
    });
  }

  Widget _constructAppBar() {
    if (_userProfile != null) {
      return DenAppbar(heading: _userProfile.user.username);
    } else {
      return const PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: SizedBox(),
      );
    }
  }

  Widget _buildBody() {
    if (_userProfile != null) {
      return NestedScrollView(
        controller: _denController,
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            JuntoDenSliverAppbar(
              profile: _userProfile,
              currentTheme: _currentTheme,
            ),
          ];
        },
        body: SafeArea(
            child: UserExpressions(
          privacy: 'Public',
          userProfile: _userProfile.user,
        )),
      );
    } else {
      return Center(
        child: JuntoProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DenBloc(
          Provider.of<UserRepo>(context, listen: false),
          Provider.of<UserDataProvider>(context, listen: false))
        ..add(LoadDen()),
      child: Scaffold(
        body: JuntoFilterDrawer(
          leftDrawer:
              const FilterDrawerContent(ExpressionContextType.Collective),
          rightMenu: JuntoDrawer(),
          scaffold: Scaffold(
            appBar: _constructAppBar(),
            floatingActionButton: ValueListenableBuilder<bool>(
              valueListenable: _isVisible,
              builder: (
                BuildContext context,
                bool visible,
                Widget child,
              ) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: visible ? 1.0 : 0.0,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: BottomNav(
                  actionsVisible: false,
                  onLeftButtonTap: () {
                    // open about page
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            AboutMember(profile: _userProfile),
                      ),
                    );
                  },
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: _buildBody(),
          ),
        ),
      ),
    );
  }
}
