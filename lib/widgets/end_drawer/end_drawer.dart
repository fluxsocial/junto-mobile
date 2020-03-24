import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/end_drawer_relationships.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundTheme(),
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .2,
            left: 32,
            bottom: MediaQuery.of(context).size.height * .2,
            right: 32,
          ),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  JuntoDrawerItem(
                    icon: _userProfile != null
                        ? Container(
                            margin: const EdgeInsets.only(right: 32),
                            child: MemberAvatar(
                              profilePicture: _userProfile.user.profilePicture,
                              diameter: 28,
                            ),
                          )
                        : const SizedBox(),
                    title: 'My Den',
                    onTap: () {
                      Navigator.of(context).push(
                        FadeRoute<void>(
                          child: JuntoDen(),
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
                        CustomIcons.infinity,
                        color: Colors.white,
                        size: 9,
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
                        )),
                    title: 'Themes',
                    onTap: () async {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return JuntoThemes(
                              refreshData: getUserInformation,
                            );
                          },
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
                  await Provider.of<AuthRepo>(
                    context,
                    listen: false,
                  ).logoutUser();
                  Navigator.of(context).pushReplacement(
                    FadeRoute<void>(
                      child: Welcome(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
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
          children: <Widget>[
            icon,
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
