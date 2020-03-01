import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
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
            child: Image.asset(
                'assets/images/junto-mobile__themes--rainbow.png',
                fit: BoxFit.cover),
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
                      icon: Container(
                        margin: const EdgeInsets.only(right: 32),
                        child: ClipOval(
                          child: Container(
                            width: 28,
                            height: 28,
                            child: Image.asset(
                                'assets/images/junto-mobile__themes--rainbow.png',
                                fit: BoxFit.cover),
                          ),
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
                            builder: (BuildContext context) => JuntoThemes(),
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
                      Icons.favorite,
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
