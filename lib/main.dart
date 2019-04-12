
import 'package:flutter/material.dart';

import './screens/collective.dart';

void main() => runApp(JuntoMobile());

class JuntoMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: JuntoCollective()
    );
  }
}