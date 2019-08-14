import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/collective_provider/collective_provider.dart';
import 'scoped_models/scoped_user.dart';
import './screens/welcome/welcome.dart';
import './screens/template/template.dart';
import './screens/create/create.dart';
import './screens/notifications/notifications.dart';

class JuntoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoAppState();
  }
}

class JuntoAppState extends State<JuntoApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => Collective(),
        child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'Avenir',
            ),
            home: Welcome(),
            routes: {
          '/welcome': (BuildContext context) => Welcome(),
          '/template': (BuildContext context) => JuntoTemplate(),
          '/create': (BuildContext context) => JuntoCreate('collective'),
          '/notifications': (BuildContext context) => JuntoNotifications(),
        }));
  }
}
