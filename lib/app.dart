
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'scoped_models/scoped_user.dart';
import './screens/welcome/welcome.dart';
import './screens/template/template.dart';
import './screens/collective/collective.dart';
import './screens/spheres/spheres.dart';
import './screens/pack/pack.dart';
import './screens/den/den.dart';
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

    return 
      ScopedModel<ScopedUser>(
        model: scopedUser,
        child:       
          MaterialApp(
            theme: ThemeData(
              fontFamily: 'Avenir', 
            ),
            home: Welcome(),
            routes: {
              '/welcome': (BuildContext context) => Welcome(),
              '/template': (BuildContext context) => JuntoTemplate(),
              '/collective': (BuildContext context) => JuntoCollective(),
              '/spheres': (BuildContext context) => JuntoSpheres(),
              '/pack': (BuildContext context) => JuntoPack(),
              '/den': (BuildContext context) => JuntoDen(),
              '/create': (BuildContext context) => JuntoCreate(),
              '/notifications': (BuildContext context) => JuntoNotifications(),
          } 
      )
    );
  }
}