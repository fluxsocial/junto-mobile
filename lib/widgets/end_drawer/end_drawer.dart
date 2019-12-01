import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/sign_in/sign_in.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_edit_den.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_themes.dart';
import 'package:provider/provider.dart';

class JuntoDrawer extends StatefulWidget {
  const JuntoDrawer(this.screen);

  final String screen;

  @override
  _JuntoDrawerState createState() => _JuntoDrawerState();
}

class _JuntoDrawerState extends State<JuntoDrawer> {
  UserProfile profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveUserInfo();
  }

  Future<void> _retrieveUserInfo() async {
    final UserRepo _userProvider = Provider.of<UserRepo>(context);
    try {
      final UserData _profile = await _userProvider.readLocalUser();
      if (mounted) {
        setState(() {
          profile = _profile.user;
        });
      }
    } catch (error) {
      debugPrint('Error occured in _retrieveUserInfo: $error');
    }
  }

  Future<void> _onPackPress() async {
    final UserGroupsResponse _userPack =
        await Provider.of<UserRepo>(context).getUserGroups(profile.address);
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

  void _onEditPress() {
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => JuntoEditDen(),
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
          color: Theme.of(context).colorScheme.background,
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            children: <Widget>[
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).dividerColor, width: .75),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.screen,
                        style: Theme.of(context).textTheme.title),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 32.0,
                        width: 32.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(
                    0,
                  ),
                  children: <Widget>[
                    // relationships

                    JuntoDrawerItem(
                      title: 'My Pack',
                      onTap: _onPackPress,
                    ),
                    JuntoDrawerItem(
                      title: 'Relationships',
                      onTap: () {
                        // open relationships
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
                      title: 'Edit Den',
                      onTap: () {
                        // nav
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) => JuntoEditDen(),
                          ),
                        );
                      },
                    ),

                    JuntoDrawerItem(
                      title: 'Logout',
                      onTap: () async {
                        await Provider.of<AuthRepo>(context).logoutUser();
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              return SignIn();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
