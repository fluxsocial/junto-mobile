import 'package:flutter/material.dart';

import './notifications_appbar/notifications_appbar.dart';

class JuntoNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: NotificationsAppbar()),
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xffeeeeee), width: 1))),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Notifications'),
                        Text('Whiteboard'),
                        Text('Updates')
                      ],
                    )),
                // Expanded(
                //     child: ListView(
                //   children: <Widget>[Text('yeo')],
                // ))
              ],
            ));
  }
}
