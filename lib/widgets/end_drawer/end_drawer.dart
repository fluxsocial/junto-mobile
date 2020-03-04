import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/drawer_item.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/zoom_scaffold.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/user_avatar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDrawerState();
}

class JuntoDrawerState extends State<JuntoDrawer> {
  String _userAddress;
  UserData _userProfile;
  String _userFollowPerspectiveId;
  String _currentTheme = 'rainbow';
  bool _nightMode;

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
      _userFollowPerspectiveId = prefs.getString('user_follow_perspective_id');
      _currentTheme = prefs.getString('current-theme');
      _nightMode = prefs.getBool('night-mode');
    });
  }

  String _displayBackground() {
    if (_currentTheme == 'rainbow' || _currentTheme == 'rainbow-night') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (_currentTheme == 'aqueous' || _currentTheme == 'aqueous-night') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (_currentTheme == 'royal' || _currentTheme == 'royal-night') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(FadeRoute<dynamic>(child: screen));
    return;
  }

  Future<void> _logout() async {
    await Provider.of<AuthRepo>(
      context,
      listen: false,
    ).logoutUser();
    _navigateToScreen(Welcome());
  }

  void onPanUpdate(DragUpdateDetails details) {
    //on swiping from left to right
    if (details.delta.dx < 6) {
      Provider.of<MenuController>(context, listen: false).toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(_displayBackground(), fit: BoxFit.cover),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .2,
              left: 80.0,
              bottom: MediaQuery.of(context).size.height * .2,
              right: 32.0,
            ),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                JuntoDrawerItem(
                  icon: JuntoUserAvatar(
                    user: _userProfile?.user,
                  ),
                  title: 'My Den',
                  onTap: () => _navigateToScreen(JuntoDen()),
                ),
                JuntoDrawerItem(
                  icon: Container(
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: 'Search',
                  onTap: () => _navigateToScreen(const GlobalSearch()),
                ),
                JuntoDrawerItem(
                  icon: Container(
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      CustomIcons.infinity,
                      color: Colors.white,
                      size: 9,
                    ),
                  ),
                  title: 'Relations',
                  onTap: () => _navigateToScreen(
                    JuntoRelationships(
                      _userAddress,
                      _userFollowPerspectiveId,
                    ),
                  ),
                ),
                JuntoDrawerItem(
                  icon: Container(
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: 'Themes',
                  onTap: () => _navigateToScreen(
                    JuntoThemes(
                      refreshData: getUserInformation,
                      currentTheme: _currentTheme,
                      nightMode: _nightMode,
                    ),
                  ),
                ),
                JuntoDrawerItem(
                  icon: Container(
                    width: 60,
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: 'Log Out',
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
