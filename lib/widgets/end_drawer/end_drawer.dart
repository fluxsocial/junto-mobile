import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/zoom_scaffold.dart';

class JuntoDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoDrawerState();
  }
}

class JuntoDrawerState extends State<JuntoDrawer> {
  String _userAddress;
  UserData _userProfile;
  String _userFollowPerspectiveId;
  String _currentTheme;

  @override
  void didChangeDependencies() {
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
    });
  }

  String _displayBackground() {
    if (_currentTheme == 'rainbow') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (_currentTheme == 'aqueous') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (_currentTheme == 'royal') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        //on swiping from left to right
        if (details.delta.dx < 6) {
          Provider.of<MenuController>(context, listen: false).toggle();
        }
      },
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
                left: 80,
                bottom: MediaQuery.of(context).size.height * .2,
                right: 32),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    JuntoDrawerItem(
                      icon: _userProfile != null &&
                              _userProfile.user.profilePicture.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(right: 32),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _userProfile.user.profilePicture[0],
                                  height: 28,
                                  width: 28,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (BuildContext context, String _) {
                                    return Container(
                                      alignment: Alignment.center,
                                      height: 28.0,
                                      width: 28.0,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          stops: const <double>[0.3, 0.9],
                                          colors: <Color>[
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Image.asset(
                                        'assets/images/junto-mobile__logo--white.png',
                                        height: 17,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: 28.0,
                              width: 28.0,
                              margin: const EdgeInsets.only(right: 32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: const <double>[0.3, 0.9],
                                  colors: <Color>[
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.asset(
                                'assets/images/junto-mobile__logo--white.png',
                                height: 12,
                              ),
                            ),
                      title: 'My Den',
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder<dynamic>(
                            pageBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                            ) {
                              return JuntoDen();
                            },
                            transitionsBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
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
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                const GlobalSearch(),
                          ),
                        );
                      },
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
                      title: 'Relations',
                      onTap: () async {
                        // open relationships
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              return JuntoRelationships(
                                  _userAddress, _userFollowPerspectiveId);
                            },
                          ),
                        );
                      },
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
                      onTap: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                JuntoThemes(refreshData: getUserInformation),
                          ),
                        );
                      },
                    ),
                  ],
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
                  onTap: () async {
                    await Provider.of<AuthRepo>(context, listen: false)
                        .logoutUser();
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder<dynamic>(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return Welcome();
                        },
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                          milliseconds: 400,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JuntoDrawerItem extends StatelessWidget {
  const JuntoDrawerItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                icon,
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
