import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

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
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hey Eric!',
                      style: TextStyle(
                          fontSize: 17,
                          color: const Color(0xff333333),
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
                    _denDrawerSection('Experience'),
                    _denDrawerItem('My Pack', 'nav'),
                    _denDrawerItem('Connections', 'nav'),
                    _denDrawerItem('Followers and following', 'nav'),
                    _denDrawerItem('Edit profile', 'nav'),
                    _denDrawerItem('Night theme', 'nav'),
                    _denDrawerItem('Notifications', 'nav'),
                    _denDrawerItem('Manage account', 'nav'),
                    _denDrawerItem('Privacy', 'nav'),
                    // Support
                    _denDrawerSection('Support'),
                    _denDrawerItem('Resources', 'nav'),
                    _denDrawerItem('Logout', 'nav'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _denDrawerSection(title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  _denDrawerItem(title, navigation) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Icon(
              Icons.keyboard_arrow_right,
              size: 17,
              color: const Color(0xff555555),
            ),
          ],
        ),
      ),
    );
  }
}
