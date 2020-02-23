import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoDrawer extends StatefulWidget {
  const JuntoDrawer({this.screen, this.icon});

  final String screen;
  final IconData icon;

  @override
  _JuntoDrawerState createState() => _JuntoDrawerState();
}

class _JuntoDrawerState extends State<JuntoDrawer> {
  String _userAddress;
  String _userFollowPerspectiveId;

  @override
  void initState() {
    super.initState();

    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userFollowPerspectiveId = prefs.getString('user_follow_perspective_id');
    });
  }

  Future<PackageInfo> getVersionNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top + 12.0;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          padding: EdgeInsets.only(top: statusBarHeight, left: 20, right: 20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                JuntoDrawerItem(
                    title: 'Search',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder<dynamic>(
                          pageBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                          ) {
                            return const GlobalSearch();
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
                    }),
                JuntoDrawerItem(
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
                    }),
                // relationships
                JuntoDrawerItem(
                  title: 'Edit Den',
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<Widget>(
                        builder: (BuildContext context) => JuntoEditDen(),
                      ),
                    );
                  },
                ),

                JuntoDrawerItem(
                  title: 'Relationships',
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
                  title: 'Themes',
                  onTap: () {
                    // nav
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext context) => JuntoThemes(),
                      ),
                    );
                  },
                ),

                JuntoDrawerItem(
                  title: 'Logout',
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
                const SizedBox(height: 50),
                FutureBuilder<PackageInfo>(
                  future: getVersionNumber(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return Container(
                        child: Text(
                          '${snapshot.data.appName} '
                          'Build Number: ${snapshot.data.buildNumber} '
                          'Version: ${snapshot.data.version}',
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: const Color(0xFFDFDFDF),
                              ),
                        ),
                      );
                    }
                    return Text(
                      'Loading ',
                      style: Theme.of(context).textTheme.caption,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JuntoDrawerItem extends StatelessWidget {
  const JuntoDrawerItem({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final String title;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
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
