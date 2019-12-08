import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/packs.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/appbar/groups_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/fabs/create_sphere_fab.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

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

  UserRepo _userProvider;
  UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    _groupsPageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _userProvider = Provider.of<UserRepo>(context);
    });
    _retrieveUserInfo();
  }

  Future<void> _retrieveUserInfo() async {
    try {
      final UserData _profile = await _userProvider.readLocalUser();
      setState(() {
        userProfile = _profile.user;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<UserGroupsResponse> getUserGroups() async {
    return _userProvider.getUserGroups(userProfile.address);
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
        endDrawer: const JuntoDrawer('Groups'),
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
                  FutureBuilder(
                    future: getUserGroups(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('something is up'),
                        );
                      }
                      if (snapshot.hasData) {
                        final List<Group> ownedGroups = snapshot.data.owned;
                        final List<Group> associatedGroups =
                            snapshot.data.associated;
                        final List<Group> userGroups = distinct<Group>(
                                ownedGroups, associatedGroups)
                            .where((Group group) => group.groupType == 'Sphere')
                            .toList();

                        return userGroups.isEmpty
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36),
                                  child: Text(
                                    'Discover communities to join by pressing the search icon in the top navigation bar or create your own by pressing the icon left of the center lotus below!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    child: const Text('success'),
                                  ),
                                  for (Group group in userGroups)
                                    SpherePreview(
                                      group: group,
                                    )
                                ],
                              );
                      }
                      return const SizedBox();
                    },
                  ),
                  JuntoPacks(
                    visibility: _isVisible,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
