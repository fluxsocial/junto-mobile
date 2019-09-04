import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/notifications/notifications_appbar/notifications_appbar.dart';

class JuntoNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: NotificationsAppbar(),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: const <Widget>[
                SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
