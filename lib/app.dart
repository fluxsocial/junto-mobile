import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
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
  ScopedUser scopedUser;

  @override
  void initState() {
    scopedUser = ScopedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ScopedUser>(
        model: scopedUser,
        child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'Avenir',
            ),
            home: Welcome(scopedUser),
            routes: {
              '/welcome': (BuildContext context) => Welcome(scopedUser),
              '/template': (BuildContext context) => JuntoTemplate(scopedUser),
              '/create': (BuildContext context) => JuntoCreate(),
              '/notifications': (BuildContext context) => JuntoNotifications(),
            }));
  }
}
