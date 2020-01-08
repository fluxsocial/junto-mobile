import 'dart:convert';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/create_sphere.dart';
import 'package:junto_beta_mobile/screens/groups/spheres/spheres.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/appbar/groups_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
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
  final AsyncMemoizer<UserGroupsResponse> _memoizer = AsyncMemoizer<UserGroupsResponse>();

  UserRepo _userProvider;

  //ignore:unused_field
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

    setState(() {
      _userProvider = Provider.of<UserRepo>(context);
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => _userProvider.getUserGroups(_userProfile.user.address),
    );
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
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(45),
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
              child: BottomNav(
                  screen: 'groups',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) => CreateSphere(),
                      ),
                    );
                  })),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        endDrawer: const JuntoDrawer(screen: 'Groups', icon: CustomIcons.groups),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
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
                          Icon(
                            CustomIcons.spheres,
                            size: 17,
                            color: _currentIndex == 0
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColorLight,
                          ),
                          const SizedBox(width: 5),
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
                          Icon(
                            CustomIcons.packs,
                            size: 17,
                            color: _currentIndex == 1
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColorLight,
                          ),
                          const SizedBox(width: 7.5),
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
            if (_userProfile != null)
              FutureBuilder<UserGroupsResponse>(
                future: getUserGroups(),
                builder: (BuildContext context, AsyncSnapshot<UserGroupsResponse> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Expanded(
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, -50),
                          child: const Text('Hmm, something is up with our server'),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final List<Group> ownedGroups = snapshot.data.owned;
                    final List<Group> associatedGroups = snapshot.data.associated;
                    final List<Group> userPacks = distinct<Group>(ownedGroups, associatedGroups)
                        .where((Group group) => group.groupType == 'Pack')
                        .toList();
                    final List<Group> userSpheres = distinct<Group>(ownedGroups, associatedGroups)
                        .where((Group group) => group.groupType == 'Sphere')
                        .toList();
                    return Expanded(
                      child: PageView(
                        controller: _groupsPageController,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: <Widget>[
                          JuntoSpheres(userProfile: _userProfile, userSpheres: userSpheres),
                          JuntoPacks(visibility: _isVisible, userProfile: _userProfile, userPacks: userPacks)
                        ],
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
                },
              ),
            if (_userProfile == null)
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0.0, -50),
                    child: JuntoProgressIndicator(),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
