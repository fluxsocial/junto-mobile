
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'scoped_models/scoped_user.dart';
import './screens/welcome/welcome.dart';
import './screens/collective/collective.dart';
import './screens/spheres/spheres.dart';
import './screens/pack/pack.dart';
import './screens/den/den.dart';
import './screens/create/create.dart';
import './screens/perspectives/perspectives.dart';

class JuntoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      ScopedModel<ScopedUser>(
        model: ScopedUser(),
        child:       
          MaterialApp(
            theme: ThemeData(
              fontFamily: 'Avenir', 
            ),
            home: Welcome(),
            routes: {
              '/welcome': (BuildContext context) => Welcome (),
              '/collective': (BuildContext context) => JuntoCollective(),
              '/spheres': (BuildContext context) => JuntoSpheres(),
              '/pack': (BuildContext context) => JuntoPack(),
              '/den': (BuildContext context) => JuntoDen(),
              '/create': (BuildContext context) => JuntoCreate(),
              '/perspectives': (BuildContext context) => JuntoPerspectives(),
          } 
      )
    );
  }
}