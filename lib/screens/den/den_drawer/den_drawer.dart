import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_connections.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_followers.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_edit_profile.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_themes.dart';
import 'package:junto_beta_mobile/screens/sign_in/sign_in.dart';
import 'package:provider/provider.dart';

class DenDrawer extends StatefulWidget {
  @override
  _DenDrawerState createState() => _DenDrawerState();
}

class _DenDrawerState extends State<DenDrawer> {
  UserProfile profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveUserInfo();
  }

  Future<void> _retrieveUserInfo() async {
    final UserService _userProvider = Provider.of<UserService>(context);
    try {
      final UserProfile _profile = await _userProvider.readLocalUser();
      if (mounted) {
        setState(() {
          profile = _profile;
        });
      }
    } catch (error) {
      debugPrint('Error occured in _retrieveUserInfo: $error');
    }
  }

// FIXME(Nash): Look up the address and retrieve the user pack
//  see: https://github.com/juntofoundation/junto-mobile/issues/170
  Future<void> _onPackPress() async {
    final UserGroupsResponse _userPack =
        await Provider.of<UserService>(context).getUserGroups(profile.address);
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

  void _onConnectionsPress() {
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => DenConnections(),
      ),
    );
  }

  void _onFollowersPress() {
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => DenFollowers(),
      ),
    );
  }

  void _onEditPress() {
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => DenEditProfile(),
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
                    Text('My Den', style: Theme.of(context).textTheme.title),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 38.0,
                        width: 38.0,
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
                    DenDrawerItem(
                      title: 'My Pack',
                      // onTap: _onPackPress,
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PackOpen(
                              pack: Group(
                                address: '',
                                createdAt: DateTime.now(),
                                creator: 'Eric Yang',
                                privacy: 'public',
                                groupType: 'sphere',
                                groupData: GroupDataPack(name: 'Urksters'),
                              ),
                            ),
                          ),
                        );
                      },
                      arrow: true,
                    ),
                    DenDrawerItem(
                      title: 'Connections',
                      onTap: _onConnectionsPress,
                      arrow: true,
                    ),
                    DenDrawerItem(
                      title: 'Subscribers/Subscriptions',
                      onTap: _onFollowersPress,
                      arrow: true,
                    ),
                    DenDrawerItem(
                      title: 'Themes',
                      onTap: () {
                        // nav
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => DenThemes(),
                          ),
                        );
                      },
                      arrow: true,
                    ),
                    DenDrawerItem(
                      title: 'Edit den',
                      onTap: _onEditPress,
                      arrow: true,
                    ),

                    // DenDrawerItem(
                    //   title: 'Manage account',
                    //   onTap: () {
                    //     // nav
                    //   },
                    //   arrow: true,
                    // ),
                    // DenDrawerItem(
                    //   title: 'Resources',
                    //   onTap: () {
                    //     // nav
                    //   },
                    //   arrow: true,
                    // ),
                    DenDrawerItem(
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
                      arrow: true,
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

class DenDrawerItem extends StatelessWidget {
  const DenDrawerItem({
    Key key,
    @required this.title,
    @required this.arrow,
    @required this.onTap,
  }) : super(key: key);

  final String title;
  final bool arrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.caption),
            arrow == true
                ? Icon(
                    Icons.keyboard_arrow_right,
                    size: 17,
                    color: Theme.of(context).primaryColor,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
