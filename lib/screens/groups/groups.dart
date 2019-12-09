import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/appbar/groups_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/fabs/create_sphere_fab.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This screen displays groups a member belongs two. Currently, there are two types of
// groups: spheres (communities) and packs (agent-centric communities)
class JuntoGroups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoGroupsState();
  }
}

class JuntoGroupsState extends State<JuntoGroups> with HideFab, ListDistinct {
  int _currentIndex = 0;
  PageController _groupsPageController;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  String _userAddress;
  UserData _userProfile;

  @override
  void initState() {
    super.initState();
    _groupsPageController = PageController(initialPage: 0);
    getUserInformation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _groupsPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: JuntoGroupsAppbar(),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (BuildContext context, bool visible, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: visible ? 1.0 : 0.0,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: _currentIndex == 0
                ? BottomNav(
                    screen: 'spheres',
                    onTap: () {
                      // open create sphere modal
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          child: CreateSphereBottomSheet(),
                        ),
                      );
                    })
                : const BottomNav(screen: 'packs'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        endDrawer:
            const JuntoDrawer(screen: 'Groups', icon: CustomIcons.spheres),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _groupsPageController.jumpToPage(0);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Spheres',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _currentIndex == 0
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _groupsPageController.jumpToPage(1);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Packs',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _currentIndex == 1
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context).primaryColorLight,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _groupsPageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                  JuntoSpheres(userProfile: _userProfile),
                  JuntoPacks(visibility: _isVisible, userProfile: _userProfile)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
