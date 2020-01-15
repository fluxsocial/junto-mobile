import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/groups/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';

class JuntoDrawer extends StatefulWidget {
  const JuntoDrawer({this.screen, this.icon});

  final String screen;
  final IconData icon;

  @override
  _JuntoDrawerState createState() => _JuntoDrawerState();
}

class _JuntoDrawerState extends State<JuntoDrawer> {
  UserData profile;
  String userAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveUserInfo();
  }

  Future<void> _retrieveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(
      prefs.getString('user_data'),
    );
    if (mounted) {
      setState(() {
        profile = UserData.fromMap(decodedUserData);
        userAddress = prefs.getString('user_id');
      });
    }
  }

  Future<void> _onPackPress() async {
    final UserGroupsResponse _userPack =
        await Provider.of<UserRepo>(context, listen: false)
            .getUserGroups(userAddress);
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) {
          return PackOpen(
            pack: _userPack.owned.first,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          padding: EdgeInsets.only(top: statusBarHeight, left: 20, right: 20),
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                        'assets/images/junto-mobile__placeholder--member.png',
                        height: 45,
                        width: 45),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
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
                        title: 'My Pack',
                        onTap: _onPackPress,
                      ),
                      JuntoDrawerItem(
                        title: 'Relationships',
                        onTap: () async {
                          final SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          // open relationships
                          Navigator.push(
                            context,
                            CupertinoPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  JuntoRelationships(
                                      _prefs.getString('user_id'),
                                      _prefs.getString(
                                          'user_follow_perspective_id')),
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
                    ],
                  )
                ],
              ),
            ],
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
