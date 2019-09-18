import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_connections.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_followers.dart';
import 'package:junto_beta_mobile/screens/den/den_drawer/den_edit_profile.dart';

class DenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            children: <Widget>[
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Hey Eric!',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700),
                    ),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 36.0,
                        width: 36.0,
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
                    _denDrawerItem(context, 'My Pack', 'pack', true),
                    _denDrawerItem(context, 'Connections', 'connections', true),
                    _denDrawerItem(
                        context, 'Followers and following', 'followers', true),
                    _denDrawerItem(context, 'Edit profile', 'edit', true),
                    // _denDrawerItem('Night theme', 'nav'),
                    // _denDrawerItem('Notifications', 'nav'),
                    // _denDrawerItem(context, 'Manage account', 'nav', true),
                    // _denDrawerItem('Privacy', 'nav'),

                    // Support
                    // _denDrawerItem('Resources', 'nav'),
                    _denDrawerItem(context, 'Logout', 'nav', false),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _denDrawerItem(context, String title, String action, arrow) {
    return GestureDetector(
      onTap: () {
        _drawerAction(action, context);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            arrow == true
                ? Icon(
                    Icons.keyboard_arrow_right,
                    size: 17,
                    color: const Color(0xff555555),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

_drawerAction(action, context) {
  if (action == 'pack') {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PackOpen('The Gnarly Nomads', 'Eric Yang',
            'assets/images/junto-mobile__eric.png'),
      ),
    );
  } else if (action == 'connections') {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DenConnections(),
      ),
    );
  } else if (action == 'followers') {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DenFollowers(),
      ),
    );
  } else if (action == 'edit') {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DenEditProfile(),
      ),
    );
  } else {
    return;
  }
}
