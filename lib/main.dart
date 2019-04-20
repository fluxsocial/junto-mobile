
import 'package:flutter/material.dart';

import './screens/collective/collective.dart';
import './screens/spheres/spheres.dart';
import './screens/pack/pack.dart';
import './screens/den/den.dart';
import './screens/create/create.dart';
import './screens/perspectives/perspectives.dart';

void main() => runApp(JuntoMobile());

class JuntoMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Avenir', 
      ),
      home: JuntoCollective(),
      routes: {
        '': (BuildContext context) => JuntoCollective(),
        '/spheres': (BuildContext context) => JuntoSpheres(),
        '/pack': (BuildContext context) => JuntoPack(),
        '/den': (BuildContext context) => JuntoDen(),
        '/create': (BuildContext context) => JuntoCreate(),
        '/perspectives': (BuildContext context) => JuntoPerspectives(),


      }
    );
  }
}