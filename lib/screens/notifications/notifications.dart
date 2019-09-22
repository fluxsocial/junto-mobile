import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:junto_beta_mobile/screens/notifications/notifications_appbar.dart';

class JuntoNotifications extends StatelessWidget {
  static Route<dynamic> route() {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoNotifications();
      },
    );
  }

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
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 280),
                  height: MediaQuery.of(context).size.height,
                  child: const Text(
                    'building this last..',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
