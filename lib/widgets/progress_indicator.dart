import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class JuntoProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      color: Theme.of(context).primaryColorLight,
      size: 50.0,
    );
  }
}
